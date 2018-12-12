//
//  URL+RTSPTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class URLPrefixTests: XCTestCase {
    
    func testShouldReturnProperUrl() {
        // Given
        let testCases = [("ip", "port"),
                         ("127.0.0.1", "443"),
                         ("255.255.255.0", "344")]
        let expectedUrls = testCases.map { ip, port in URL(string: "ws://\(ip):\(port)") }
        
        // When
        let actualUrls = testCases.map { ip, port in URL.with(ip: ip, port: port, prefix: Constants.protocolPrefix) }
        
        // Then
        zip(expectedUrls, actualUrls).forEach { expectedUrl, actualUrl in
            XCTAssertEqual(expectedUrl, actualUrl)
        }
    }

}
