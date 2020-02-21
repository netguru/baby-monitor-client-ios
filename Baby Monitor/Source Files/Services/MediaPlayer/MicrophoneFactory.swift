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
    var tracker: MicrophoneAmplitudeTracker { get }
}

struct AudioKitMicrophone: AudioKitMicrophoneProtocol {
    var record: MicrophoneRecordProtocol
    var capture: MicrophoneCaptureProtocol
    var tracker: MicrophoneAmplitudeTracker
}

enum AudioKitMicrophoneFactory {

    static var makeMicrophoneFactory: () throws -> AudioKitMicrophoneProtocol? = {

        AKSettings.bufferLength = .medium
        AKSettings.channelCount = 1
        AKSettings.audioInputEnabled = true
        AKSettings.defaultToSpeaker = true

        try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)

        let recordingFormat = AudioKit.engine.inputNode.inputFormat(forBus: 0)
        AKSettings.sampleRate = recordingFormat.sampleRate

        let microphone = AKMicrophone(with: recordingFormat)

        let recorderMixer = AKMixer(microphone)
        let capturerMixer = AKMixer(microphone)

        let tracker = AKAmplitudeTracker(capturerMixer)

        let recorder = try AKNodeRecorder(node: recorderMixer)
        let capturer = try AudioKitNodeCapture(node: tracker)

        let silentRecorderMixer = AKMixer(recorderMixer)
        silentRecorderMixer.volume = 0
        let silentCapturerMixer = AKMixer(tracker)
        silentCapturerMixer.volume = 0

        let outputMixer = AKMixer(silentRecorderMixer, silentCapturerMixer)

        AudioKit.output = outputMixer
        try AudioKit.start()

        return AudioKitMicrophone(record: recorder, capture: capturer, tracker: tracker)
    }
}

protocol MicrophoneRecordProtocol: Any {
    var audioFile: AKAudioFile? { get }
    
    func stop()
    func record() throws
    func reset() throws
}

protocol MicrophoneCaptureProtocol: Any {
    var bufferReadable: Observable<AVAudioPCMBuffer> { get }
    var isCapturing: Bool { get }

    func stop()
    func start() throws
    func reset() throws
}

extension AKNodeRecorder: MicrophoneRecordProtocol {}
extension AudioKitNodeCapture: MicrophoneCaptureProtocol {}
