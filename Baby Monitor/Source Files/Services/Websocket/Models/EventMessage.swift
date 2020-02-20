//
//  EventMessage.swift
//  Baby Monitor
//

import Foundation

enum BabyMonitorEvent: String, CodingKey {
    case pushNotificationsKey = "pushNotificationsToken"
    case actionKey = "action"
    case pairingCodeKey = "pairingCode"
    case pairingCodeResponseKey = "pairingResponse"
    case webRtcSdpErrorKey = "errorSDP"
    case soundDetectionModeKey = "voiceAnalysisOption"
    case confirmationID = "confirmationId"
}

enum BabyMonitorEvenAction: String, Codable {
    case reset
}

struct EventMessage {
    var pushNotificationsToken: String?
    var action: BabyMonitorEvenAction?
    var pairingCode: String?
    var pairingCodeResponse: Bool?
    var webRtcSdpErrorMessage: String?
    var soundDetectionMode: SoundDetectionMode?
    var confirmationId: String?
}

extension EventMessage: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BabyMonitorEvent.self)
        pushNotificationsToken = try container.decodeIfPresent(String.self, forKey: .pushNotificationsKey)
        action = try container.decodeIfPresent(BabyMonitorEvenAction.self, forKey: .actionKey)
        pairingCode = try container.decodeIfPresent(String.self, forKey: .pairingCodeKey)
        pairingCodeResponse = try container.decodeIfPresent(Bool.self, forKey: .pairingCodeResponseKey)
        webRtcSdpErrorMessage = try container.decodeIfPresent(String.self, forKey: .webRtcSdpErrorKey)
        soundDetectionMode = try container.decodeIfPresent(SoundDetectionMode.self, forKey: .soundDetectionModeKey)
        confirmationId = try container.decodeIfPresent(String.self, forKey: .confirmationID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BabyMonitorEvent.self)
        try container.encodeIfPresent(pushNotificationsToken, forKey: .pushNotificationsKey)
        try container.encodeIfPresent(action, forKey: .actionKey)
        try container.encodeIfPresent(pairingCode, forKey: .pairingCodeKey)
        try container.encodeIfPresent(pairingCodeResponse, forKey: .pairingCodeResponseKey)
        try container.encodeIfPresent(webRtcSdpErrorMessage, forKey: .webRtcSdpErrorKey)
        try container.encodeIfPresent(soundDetectionMode, forKey: .soundDetectionModeKey)
        try container.encodeIfPresent(confirmationId, forKey: .confirmationID)
    }
}
