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
    private let bufferFormat: AVAudioFormat
    private let bufferQueue = DispatchQueue(label: "co.netguru.netguru.babymonitor.AudioKitNodeCapture.bufferQueue", qos: .default)
    
    init(node: AKNode? = AudioKit.output, bufferSize: UInt32 = 264600) throws {
        self.node = node
        self.bufferSize = bufferSize
        self.bufferFormat = node?.avAudioUnitOrNode.inputFormat(forBus: 0) ?? AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100.0, channels: 1, interleaved: false)!
        self.internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: bufferSize)!
    }

    /// Start Capturing
    func start() throws {
        guard !isCapturing, let node = node else {
            return
        }
        node.avAudioUnitOrNode.installTap(onBus: 0, bufferSize: AKSettings.bufferLength.samplesCount, format: node.avAudioUnitOrNode.inputFormat(forBus: 0)) { [weak self] buffer, _ in
            self?.bufferQueue.async {
                guard let self = self else { return }
                let samplesLeft = self.internalAudioBuffer.frameCapacity - self.internalAudioBuffer.frameLength
                if buffer.frameLength < samplesLeft {
                    self.internalAudioBuffer.copy(from: buffer)
                } else {
                    self.bufferReadableSubject.onNext(self.internalAudioBuffer.copy() as! AVAudioPCMBuffer)
                    self.internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: self.bufferFormat, frameCapacity: self.bufferSize)!
                    self.internalAudioBuffer.copy(from: buffer)
                }
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
    }
    
    /// Reset the Buffer to clear previous recordings
    func reset() throws {
        stop()
        internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: bufferSize)!
    }
}
