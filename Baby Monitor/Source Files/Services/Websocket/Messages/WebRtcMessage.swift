//
//  WebRtcMessage.swift
//  Baby Monitor
//

import WebRTC

enum WebRtcMessage: Equatable {
    case sdpAnswer(RTCSessionDescription)
    case sdpOffer(RTCSessionDescription)
    case iceCandidate(RTCICECandidate)
    
    enum Key: String {
        case offerSDP
        case answerSDP
        case iceCandidate
    }
}
