//
//  WebsocketMessageDecodableTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class WebsocketMessageDecodableTests: XCTestCase {

    func testShouldConvertString() {
        // Given
        let string = "string"

        // When
        let result = (string as WebsocketMessageDecodable).decode()

        // Then
        XCTAssertEqual(result, string)
    }

    func testShouldConvertUTF8Data() {
        // Given
        let string = "string"
        let data = string.data(using: .utf8)!

        // When
        let result = (data as WebsocketMessageDecodable).decode()

        // Then
        XCTAssertEqual(result, string)
    }
}
