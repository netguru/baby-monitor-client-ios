//
//  WebRtcConstraintKey.swift
//  Baby Monitor
//

enum WebRtcConstraintKey {
    static let dtlsSrtpKeyAgreement = "DtlsSrtpKeyAgreement"
    static let offerToReceiveAudio = "OfferToReceiveAudio"
    static let offerToReceiveVideo = "OfferToReceiveVideo"
    static let iceRestart = "iceRestart"
}

enum WebRtcConstraintValue {
    static let `true` = "true"
}
