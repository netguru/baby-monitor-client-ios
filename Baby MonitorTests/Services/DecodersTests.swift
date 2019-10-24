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
        let sdp = RTCSessionDescription(type: RTCSdpType.answer, sdp: "test")
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.answerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpAnswer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.sdp, sdpAnswer.sdp)
            XCTAssertEqual(sdp.stringType, sdpAnswer.stringType)
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
    
    func testShouldDecodeSdpOffer() {
        // Given
        let sut = SdpOfferDecoder()
        let sdp = RTCSessionDescription(type: RTCSdpType.offer, sdp: "test")
        let sdpJson = sdp.jsonDictionary()
        let sdpNetworkJson = [WebRtcMessage.Key.offerSDP.rawValue: sdpJson]
        let jsonString = sdpNetworkJson.jsonString!
        
        // When
        let decodedMessage = sut.decode(message: jsonString)!
        
        // Then
        if case let .sdpOffer(sdpAnswer) = decodedMessage {
            XCTAssertEqual(sdp.sdp, sdpAnswer.sdp)
            XCTAssertEqual(sdp.stringType, sdpAnswer.stringType)
        } else {
            XCTAssertTrue(false, "Decoded message type doesn't match")
        }
    }
}
