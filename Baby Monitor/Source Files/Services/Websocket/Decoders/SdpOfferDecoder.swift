//
//  SdpOfferDecoder.swift
//  Baby Monitor
//

final class SdpOfferDecoder: MessageDecoderProtocol {
    
    typealias T = WebRtcMessage
    
    func decode(message: String) -> WebRtcMessage? {
        guard let jsonDictionary = message.jsonDictionary,
            let sdpDictionary = jsonDictionary[WebRtcMessage.Key.offerSDP.rawValue],
            let sdp = RTCSessionDescription(dictionary: sdpDictionary) else {
                return nil
        }
        return .sdpOffer(sdp)
    }
}
