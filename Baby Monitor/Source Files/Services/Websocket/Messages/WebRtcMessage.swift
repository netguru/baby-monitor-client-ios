//
//  WebRtcMessage.swift
//  Baby Monitor
//

enum WebRtcMessage {
    case sdpAnswer(SessionDescriptionProtocol)
    case sdpOffer(SessionDescriptionProtocol)

    enum Key: String {
        case offerSDP
        case answerSDP
    }
}
