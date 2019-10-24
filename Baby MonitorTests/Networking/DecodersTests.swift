//
//  DecodersTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import WebRTC

class DecodersTests: XCTestCase {

    func testShouldDecodeSdpAnswer() {
        // Given
        let sut = SdpAnswerDecoder()
        let sdp = RTCSessionDescription(type: .answer, sdp: "test")
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.answerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpAnswer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.sdp, sdpAnswer.sdp)
            XCTAssertEqual(sdp.type, RTCSdpType.type(for: sdpAnswer.stringType))
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
    
    func testShouldDecodeSdpOffer() {
        // Given
        let sut = SdpOfferDecoder()
        let sdp = RTCSessionDescription(type: .offer, sdp: "test")
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.offerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpOffer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.sdp, sdpAnswer.sdp)
            XCTAssertEqual(sdp.type, RTCSdpType.type(for: sdpAnswer.stringType))
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
    
    func testShouldDecodeIceCandidate() {
        // Given
        let sut = IceCandidateDecoder()
        let ice = RTCIceCandidate(sdp: "sdp", sdpMLineIndex: 0, sdpMid: "mid")
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
