//
//  DecodersTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest

class DecodersTests: XCTestCase {

    func testShouldDecodeSdpAnswer() {
        // Given
        let sut = SdpAnswerDecoder()
        let sdp = RTCSessionDescription(type: "test", sdp: "test")!
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.answerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpAnswer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.description, sdpAnswer.sdp)
            XCTAssertEqual(sdp.type, sdpAnswer.stringType)
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
    
    func testShouldDecodeSdpOffer() {
        // Given
        let sut = SdpOfferDecoder()
        let sdp = RTCSessionDescription(type: "test", sdp: "test")!
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.offerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpOffer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.description, sdpAnswer.sdp)
            XCTAssertEqual(sdp.type, sdpAnswer.stringType)
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
    
    func testShouldDecodeIceCandidate() {
        // Given
        let sut = IceCandidateDecoder()
        let ice = RTCICECandidate(mid: "mid", index: 0, sdp: "sdp")!
        let iceJson = ice.jsonDictionary()
        let iceNetworkJson = [WebRtcMessage.Key.iceCandidate.rawValue: iceJson]
        let jsonString = iceNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .iceCandidate(iceCandidate) = decodedMessage {
            XCTAssertEqual(ice.sdp, iceCandidate.sdp)
            XCTAssertEqual(ice.sdpMid, iceCandidate.sdpMid)
            XCTAssertEqual(ice.sdpMLineIndex, iceCandidate.sdpMLineIndex)
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }

}
