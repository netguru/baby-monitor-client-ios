//
//  WebRtcMessage.swift
//  Baby Monitor
//

enum WebRtcMessage {
    case sdpAnswer(SessionDescriptionProtocol)
    case sdpOffer(SessionDescriptionProtocol)
    case iceCandidate(IceCandidateProtocol)
    
    enum Key: String {
        case offerSDP
        case answerSDP
        case iceCandidate
    }
}
