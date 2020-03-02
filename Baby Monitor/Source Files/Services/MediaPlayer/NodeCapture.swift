//
//  NodeCapture.swift
//  Baby Monitor
//

import Foundation
import AudioKit
import RxSwift
import RxCocoa

final class AudioKitNodeCapture: NSObject {
    
    enum AudioCaptureError: Error {
        case initializationFailure
        case captureFailure
    }

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
                self.handleBuffer(buffer)
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

    /// Handle each new buffer: convert it to needed format and pass it further.
    private func handleBuffer(_ buffer: AVAudioPCMBuffer) {
        let convertedBuffer = AVAudioPCMBuffer(pcmFormat: self.machineLearningFormat, frameCapacity: buffer.frameCapacity)!
         var error: NSError?
         let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
          outStatus.pointee = AVAudioConverterInputStatus.haveData
          return buffer
        }
         self.formatConverter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)
         if let error = error {
             Logger.error("Failed to convert audio data", error: error)
         } else {
             let samplesLeft = self.internalAudioBuffer.frameCapacity - self.internalAudioBuffer.frameLength
             if convertedBuffer.frameLength < samplesLeft {
                 self.internalAudioBuffer.copy(from: convertedBuffer)
             } else {
                 self.bufferReadableSubject.onNext(self.internalAudioBuffer.copy() as! AVAudioPCMBuffer)
             }
         }
    }
}
