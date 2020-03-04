//
//  NodeCapture.swift
//  Baby Monitor
//

import Foundation
import AudioKit
import RxSwift
import RxCocoa

final class AudioKitNodeCapture: NSObject {

    private let bufferReadableSubject = PublishSubject<AVAudioPCMBuffer>()
    lazy var bufferReadable = bufferReadableSubject.asObservable()

    private(set) var isCapturing: Bool = false
    private var node: AKNode?
    private let bufferSize: UInt32
    private var internalAudioBuffer: AVAudioPCMBuffer
    private let inputBufferFormat: AVAudioFormat
    private let bufferQueue = DispatchQueue(label: "co.netguru.netguru.babymonitor.AudioKitNodeCapture.bufferQueue", qos: .default)
    private let machineLearningFormat: AVAudioFormat
    private let formatConverter: AVAudioConverter
    
    init(node: AKNode? = AudioKit.output, bufferSize: UInt32 = MachineLearningAudioConstants.bufferSize) throws {
        self.node = node
        self.bufferSize = bufferSize
        self.inputBufferFormat = node?.avAudioUnitOrNode.inputFormat(forBus: 0) ?? AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000.0, channels: 1, interleaved: false)!
        machineLearningFormat = AVAudioFormat(commonFormat: MachineLearningAudioConstants.audioFormat,
                                              sampleRate: MachineLearningAudioConstants.sampleRate,
                                              channels: MachineLearningAudioConstants.channels,
                                              interleaved: MachineLearningAudioConstants.isInterleaved)!
        internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: machineLearningFormat, frameCapacity: bufferSize)!
        formatConverter = AVAudioConverter(from: inputBufferFormat, to: machineLearningFormat)!
    }

    /// Start Capturing
    func start() throws {
        guard !isCapturing else {
            return
        }
        node?.avAudioUnitOrNode.installTap(onBus: 0, bufferSize: AKSettings.bufferLength.samplesCount, format: node?.avAudioUnitOrNode.inputFormat(forBus: 0)) { [weak self] buffer, _ in
            self?.bufferQueue.async {
                guard let self = self else { return }
                let convertionResult = self.convertBufferIfNeeded(buffer)
                self.mergeBufferToNeededFrameCapacity(convertionResult)
            }
        }
        isCapturing = true
    }
    
    /// Stop Capturing
    func stop() {
        guard isCapturing else {
            return
        }
        node?.avAudioUnitOrNode.removeTap(onBus: 0)
        node = nil
    }
    
    /// Reset the Buffer to clear previous recordings
    func reset() throws {
        stop()
        internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: machineLearningFormat, frameCapacity: bufferSize)!
    }

    /// Converts buffer to the needed machine learning format if it's not using it yet.
    private func convertBufferIfNeeded(_ buffer: AVAudioPCMBuffer) -> Result<AVAudioPCMBuffer> {
        guard inputBufferFormat.sampleRate != machineLearningFormat.sampleRate else {
            return .success(buffer)
        }
        let sampleRateRatio = inputBufferFormat.sampleRate / machineLearningFormat.sampleRate
        let frameCapacity = UInt32(Double(buffer.frameCapacity) / sampleRateRatio)
        let convertedBuffer = AVAudioPCMBuffer(pcmFormat: machineLearningFormat, frameCapacity: frameCapacity)!
        convertedBuffer.frameLength = convertedBuffer.frameCapacity
        var convertionError: NSError?
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            outStatus.pointee = AVAudioConverterInputStatus.haveData
            return buffer
        }
        formatConverter.convert(to: convertedBuffer, error: &convertionError, withInputFrom: inputBlock)
        if let error = convertionError {
            Logger.error("Failed to convert audio data", error: error)
            return .failure(error)
        } else {
            return .success(convertedBuffer)
        }
    }

    /// Merges buffers till it doesn't fill up the needed frame capacity for the machine learning model.
    /// And passes it when ready to bufferReadableSubject.
    private func mergeBufferToNeededFrameCapacity(_ bufferResult: Result<AVAudioPCMBuffer>) {
        switch bufferResult {
        case .success(let buffer):
            let samplesLeft = internalAudioBuffer.frameCapacity - internalAudioBuffer.frameLength
            if buffer.frameLength < samplesLeft {
                internalAudioBuffer.copy(from: buffer)
            } else {
                bufferReadableSubject.onNext(internalAudioBuffer.copy() as! AVAudioPCMBuffer)
                internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: self.machineLearningFormat, frameCapacity: bufferSize)!
                internalAudioBuffer.copy(from: buffer)
            }
        case .failure(let error):
            guard let error = error else {
                assertionFailure()
                Logger.error("Error shouldn't be nil.")
                return
            }
            bufferReadableSubject.onError(error)
        }
    }
}
