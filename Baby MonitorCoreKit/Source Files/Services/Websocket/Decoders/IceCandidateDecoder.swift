//
//  IceCandidateDecoder.swift
//  Baby Monitor
//

import WebRTC

final class IceCandidateDecoder: MessageDecoderProtocol {
    
    typealias T = WebRtcMessage

    func decode(message: String) -> WebRtcMessage? {
        guard let jsonDictionary = message.jsonDictionary,
            let iceDictionary = jsonDictionary[WebRtcMessage.Key.iceCandidate.rawValue],
            let candidate = RTCIceCandidate(dictionary: iceDictionary) else {
                return nil
        }
        return .iceCandidate(candidate)
    }
}
