//
//  String+WebsocketMessageTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class StringWebsocketMessageTests: XCTestCase {

    func testShouldReturnStringFromString() {
        // Given
        let string = "string"

        // When
        let result = String.from(websocketMessage: string)

        // Then
        XCTAssertEqual(result, string)
    }

    func testShouldReturnStringFromUTF8Data() {
        // Given
        let string = "string"
        let data = string.data(using: .utf8)!

        // When
        let result = String.from(websocketMessage: data)

        // Then
        XCTAssertEqual(result, string)
    }
}
