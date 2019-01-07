//
//  IceCandidateDecoder.swift
//  Baby Monitor
//

final class IceCandidateDecoder: MessageDecoderProtocol {
    
    typealias T = WebRtcMessage

    func decode(message: String) -> WebRtcMessage? {
        guard let jsonDictionary = message.jsonDictionary,
            let iceDictionary = jsonDictionary[WebRtcMessage.Key.iceCandidate.rawValue],
            let candidate = RTCICECandidate(dictionary: iceDictionary) else {
                return nil
        }
        return .iceCandidate(candidate)
    }
}
