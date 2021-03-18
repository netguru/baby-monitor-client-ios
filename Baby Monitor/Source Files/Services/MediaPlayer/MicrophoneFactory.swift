//
//  MicrophoneFactory.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import AudioKit

protocol AudioKitMicrophoneProtocol {
    var capture: MicrophoneCaptureProtocol { get }
    var tracker: MicrophoneAmplitudeTracker { get }
}

struct AudioKitMicrophone: AudioKitMicrophoneProtocol {
    var capture: MicrophoneCaptureProtocol
    var tracker: MicrophoneAmplitudeTracker
}

enum AudioKitMicrophoneFactory {

    static var makeMicrophoneFactory: () throws -> AudioKitMicrophoneProtocol? = {

        AKSettings.channelCount = 1
        AKSettings.audioInputEnabled = true
        AKSettings.defaultToSpeaker = true

        try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)

        let recordingFormat = AKManager.engine.inputNode.inputFormat(forBus: 0)
        AKSettings.sampleRate = recordingFormat.sampleRate

        let microphone = AKMicrophone(with: recordingFormat)
        let capturerMixer = AKMixer(microphone)
        let tracker = AKAmplitudeTracker(capturerMixer)
        let capturer = try AudioKitNodeCapture(node: tracker)
        let silentCapturerMixer = AKMixer(tracker)
        silentCapturerMixer.volume = 0

        AKManager.output = silentCapturerMixer
        try AKManager.start()

        return AudioKitMicrophone(capture: capturer, tracker: tracker)
    }
}

protocol MicrophoneCaptureProtocol: Any {
    var bufferReadable: Observable<AVAudioPCMBuffer> { get }
    var isCapturing: Bool { get }

    func stop()
    func start() throws
    func reset() throws
}

extension AudioKitNodeCapture: MicrophoneCaptureProtocol {}
