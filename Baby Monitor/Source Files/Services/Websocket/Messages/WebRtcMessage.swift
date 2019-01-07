//
//  WebRtcMessage.swift
//  Baby Monitor
//

enum WebRtcMessage {
    case sdpAnswer(RTCSessionDescription)
    case sdpOffer(RTCSessionDescription)
    case iceCandidate(RTCICECandidate)
    
    enum Key: String {
        case offerSDP
        case answerSDP
        case iceCandidate
    }
}
