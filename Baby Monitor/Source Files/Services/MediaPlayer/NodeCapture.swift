//
//  NodeCapture.swift
//  Baby Monitor
//


import Foundation
import AudioKit
import RxSwift
import RxCocoa

class AudioKitNodeCapture: NSObject {
    
    enum AudioCaptureError: Error {
        case initializationFailure
        case captureFailure
    }

    private let bufferReadableSubject = PublishSubject<AVAudioPCMBuffer>()
    lazy var bufferReadable = bufferReadableSubject.asObservable()

    private(set) var isCapturing: Bool = false
    private var node: AKNode?
    private let bufferSize: UInt32
    private var internalAudioBuffer: AVAudioPCMBuffer?
    private let bufferFormat: AVAudioFormat?
    

    public init(node: AKNode? = AudioKit.output, bufferSize: UInt32 = 264600) throws {
        self.node = node
        self.bufferSize = bufferSize

        self.bufferFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                          sampleRate: 44100.0,
                                          channels: 1,
                                          interleaved: false)
        guard let bufferFormat = bufferFormat else {
            throw AudioCaptureError.initializationFailure
        }
        self.internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: bufferSize)
    }
    
    /// Start Capturing
    func start() throws {
        guard !isCapturing else {
            return
        }
        guard let node = node else {
            return
        }
        
        guard let internalAudioBuffer = internalAudioBuffer else {
            return
        }
        
        node.avAudioUnitOrNode.installTap(
            onBus: 0,
            bufferSize: AKSettings.bufferLength.samplesCount,
            format: internalAudioBuffer.format) { [weak self] (buffer: AVAudioPCMBuffer!, _) -> Void in
                
                guard let strongSelf = self else {
                    AKLog("Error: self is nil")
                    return
                }
                
                guard let internalAudioBuffer = strongSelf.internalAudioBuffer else {
                    AKLog("Error: internalAudioBuffer is nil")
                    return
                }
                
                let samplesLeft = internalAudioBuffer.frameCapacity - internalAudioBuffer.frameLength
                
                if(buffer.frameLength < samplesLeft) {
                    internalAudioBuffer.copy(from: buffer)
                }
                else if(buffer.frameLength >= samplesLeft) {
                    internalAudioBuffer.copy(from: buffer, readOffset: 0, frames: samplesLeft)
                    print("Buffer is filled. Pushing observe event")
                    strongSelf.bufferReadableSubject.onNext(internalAudioBuffer.copy() as! AVAudioPCMBuffer)
                    guard let bufferFormat = strongSelf.bufferFormat else {
                        AKLog("Error: bufferFormat is nil")
                        return
                    }
                    strongSelf.internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: strongSelf.bufferSize)
                }
                if(buffer.frameLength > samplesLeft) {
                    internalAudioBuffer.copy(from: buffer, readOffset: samplesLeft, frames: buffer.frameLength - samplesLeft)
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
        guard let bufferFormat = bufferFormat else {
            AKLog("Error: bufferFormat is nil")
            return
        }
        internalAudioBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: bufferSize)
    }
}
