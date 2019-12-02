//
//  MicrophoneFactory.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import AudioKit

protocol AudioKitMicrophoneProtocol {
    var record: MicrophoneRecordProtocol { get }
    var capture: MicrophoneCaptureProtocol { get }
}

struct AudioKitMicrophone: AudioKitMicrophoneProtocol {
    var record: MicrophoneRecordProtocol
    var capture: MicrophoneCaptureProtocol
}

enum AudioKitMicrophoneFactory {

    static var makeMicrophoneFactory: () throws -> AudioKitMicrophoneProtocol? = {

        AKSettings.bufferLength = .medium
        AKSettings.channelCount = 1
        AKSettings.audioInputEnabled = true
        AKSettings.defaultToSpeaker = true

        try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)

        let recordingFormat = AudioKit.engine.inputNode.inputFormat(forBus: 0)
        AKSettings.sampleRate = AVAudioSession.sharedInstance().sampleRate

        let microphone = AKMicrophone(with: recordingFormat)

        let recorder = try AKNodeRecorder(node: microphone)
        let capturer = try AudioKitNodeCapture(node: microphone)

        let recorderBooster = AKBooster(microphone, gain: 0)
        let capturerBooster = AKBooster(microphone, gain: 0)

        let outputMixer = AKMixer(capturerBooster, recorderBooster)

        AudioKit.output = outputMixer
        try AudioKit.start()

        return AudioKitMicrophone(record: recorder, capture: capturer)
    }
}

protocol MicrophoneRecordProtocol: Any {
    var audioFile: AKAudioFile? { get }
    
    func stop()
    func record() throws
    func reset() throws
    func removeTap()
}

protocol MicrophoneCaptureProtocol: Any {
    var bufferReadable: Observable<AVAudioPCMBuffer> { get }
    var isCapturing: Bool { get }

    func stop()
    func start() throws
    func reset() throws
}

extension AKNodeRecorder: MicrophoneRecordProtocol {

    func removeTap() {
        node?.avAudioUnitOrNode.removeTap(onBus: 0)
    }
}
extension AudioKitNodeCapture: MicrophoneCaptureProtocol {}
