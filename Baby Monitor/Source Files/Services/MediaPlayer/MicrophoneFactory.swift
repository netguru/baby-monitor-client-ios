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
    
    private static var recorder: AKNodeRecorder?
    private static var capture: AudioKitNodeCapture?
    private static var recorderBooster: AKBooster?
    private static var player: AKPlayer?
    private static var captureBooster: AKBooster?
    private static var recorderSilenceBooster: AKBooster?
    private static var captureSilenceBooster: AKBooster?
    private static var monoToStereo: AKStereoFieldLimiter?
    private static var recorderMixer: AKMixer?
    private static var captureMixer: AKMixer?
    private static var mainMixer: AKMixer?
    private static var microphone = AKMicrophone()
    
    static var makeMicrophoneFactory: () throws -> AudioKitMicrophoneProtocol? = {
        AKSettings.bufferLength = .medium
        AKSettings.sampleRate = 44100.0
        AKSettings.channelCount = 1
    
        try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        AKSettings.defaultToSpeaker = true
        
        recorderBooster = AKBooster(microphone)
        captureBooster = AKBooster(microphone)
        
        monoToStereo = AKStereoFieldLimiter(recorderBooster, amount: 1)
        recorderMixer = AKMixer(monoToStereo)
        recorder = try AKNodeRecorder(node: recorderMixer)
        capture = try AudioKitNodeCapture(node: captureBooster)
        recorderSilenceBooster = AKBooster(recorderMixer)
        recorderSilenceBooster?.gain = 0.0
        captureSilenceBooster = AKBooster(captureBooster)
        captureSilenceBooster?.gain = 0.0
        
        guard let recorder = recorder, let capture = capture, let audioFile = recorder.audioFile else {
            return nil
        }
        player = AKPlayer(audioFile: audioFile)
        mainMixer = AKMixer(player, recorderSilenceBooster)
        AudioKit.output = mainMixer
        try AudioKit.start()

        return AudioKitMicrophone(record: recorder, capture: capture)
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
