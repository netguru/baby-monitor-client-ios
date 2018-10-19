//
//  UserDefaultsRTSPConfiguration.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class UserDefaultsRTSPConfigurationTests: XCTestCase {
    
    private let testUrl = URL(string: "http://www.netguru.co")!

    func testShouldSaveUrlToUnderlyingUserDefaults() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsRTSPConfiguration(userDefaults: userDefaults)
        
        // When
        sut.url = testUrl
        
        // Then
        XCTAssertEqual(testUrl, userDefaults.url(forKey: UserDefaultsRTSPConfiguration.keyUrl))
    }
    
    func testShouldReturnNilIfNothingIsSaved() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsRTSPConfiguration(userDefaults: userDefaults)
        
        // When
        
        // Then
        XCTAssertNil(sut.url)
    }
    
    func testShouldPrefereCachedValues() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsRTSPConfiguration(userDefaults: userDefaults)
        
        // When
        sut.url = testUrl
        _ = sut.url
        
        // Then
        XCTAssertEqual(0, userDefaults.urlCallCount)
    }

    func testShouldGetValueFromUserDefaultsIfNothingIsCached() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsRTSPConfiguration(userDefaults: userDefaults)
        userDefaults.set(testUrl, forKey: UserDefaultsRTSPConfiguration.keyUrl)
        
        // When
        let actualUrl = sut.url
        
        // Then
        XCTAssertEqual(actualUrl, testUrl, "Urls doesn't match")
        XCTAssertEqual(1, userDefaults.urlCallCount, "Url method of user defaults wasn't called")
    }

}
