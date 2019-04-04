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
        AKSettings.sampleRate = 44100.0
        AKSettings.channelCount = 1
        AKSettings.audioInputEnabled = true
        AKSettings.defaultToSpeaker = true

        try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)

        let microphone = AKMicrophone()

        let recorderBooster = AKBooster(microphone)
        let capturerBooster = AKBooster(microphone)
        let recorderMixer = AKMixer(recorderBooster)

        let recorder = try AKNodeRecorder(node: recorderMixer)
        let capturer = try AudioKitNodeCapture(node: capturerBooster)

        let outputMixer = AKMixer(recorderMixer)
        outputMixer.volume = 0

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
