//
//  WebRtcMessage.swift
//  Baby Monitor
//

<<<<<<< HEAD
enum WebRtcMessage {
    case sdpAnswer(SessionDescriptionProtocol)
    case sdpOffer(SessionDescriptionProtocol)
    case iceCandidate(IceCandidateProtocol)
=======
import WebRTC

enum WebRtcMessage: Equatable {
    case sdpAnswer(RTCSessionDescription)
    case sdpOffer(RTCSessionDescription)
    case iceCandidate(RTCICECandidate)
>>>>>>> d2863fb... Replaced RTSP with WebRTC
    
    enum Key: String {
        case offerSDP
        case answerSDP
        case iceCandidate
    }
}
