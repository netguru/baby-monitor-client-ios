//
//  SDPAnswerDecoder.swift
//  Baby Monitor
//

final class SdpAnswerDecoder: MessageDecoderProtocol {
    
    typealias T = WebRtcMessage
    
    func decode(message: String) -> WebRtcMessage? {
        guard let jsonDictionary = message.jsonDictionary,
            let sdpDictionary = jsonDictionary[WebRtcMessage.Key.answerSDP.rawValue],
            let sdp = RTCSessionDescription(dictionary: sdpDictionary) else {
            return nil
        }
        return .sdpAnswer(sdp)
    }
}
