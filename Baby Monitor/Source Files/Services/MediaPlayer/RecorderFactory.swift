//
//  RecorderFactory.swift
//  Baby Monitor
//

import Foundation
import AudioKit

enum AudioKitRecorderFactory {
    
    private static var recorder: AKNodeRecorder?
    private static var player: AKPlayer?
    private static var micMixer: AKMixer?
    private static var micBooster: AKBooster?
    private static var moogLadder: AKMoogLadder?
    private static var mainMixer: AKMixer?
    private static let microphone = AKMicrophone()
    
    static var makeRecorderFactory: () -> RecorderProtocol? = {
        // Session settings
        AKSettings.bufferLength = .medium
        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            return nil
        }
        AKSettings.defaultToSpeaker = true
        // Patching
        let monoToStereo = AKStereoFieldLimiter(microphone, amount: 1)
        micMixer = AKMixer(monoToStereo)
        micBooster = AKBooster(micMixer)
        // Will set the level of microphone monitoring
        micBooster?.gain = 0
        do {
            recorder = try AKNodeRecorder(node: micMixer)
        } catch {
            return nil
        }
        guard let audioFile = recorder?.audioFile else {
            return nil
        }
        player = AKPlayer(audioFile: audioFile)
        moogLadder = AKMoogLadder(player)
        mainMixer = AKMixer(moogLadder, micBooster)
        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        } catch {
            return nil
        }
        return recorder
    }
}
