//
//  UserDefaultsURLConfiguration.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class UserDefaultsURLConfigurationTests: XCTestCase {
    
    private let testUrl = URL(string: "http://www.netguru.co")!

    func testShouldSaveUrlToUnderlyingUserDefaults() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsURLConfiguration(userDefaults: userDefaults)
        
        // When
        sut.url = testUrl
        
        // Then
        XCTAssertEqual(testUrl, userDefaults.url(forKey: UserDefaultsURLConfiguration.keyUrl))
    }
    
    func testShouldReturnNilIfNothingIsSaved() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsURLConfiguration(userDefaults: userDefaults)
        
        // When
        
        // Then
        XCTAssertNil(sut.url)
    }
    
    func testShouldPreferCachedValues() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsURLConfiguration(userDefaults: userDefaults)
        
        // When
        sut.url = testUrl
        _ = sut.url
        
        // Then
        XCTAssertEqual(0, userDefaults.urlCallCount)
    }

    func testShouldGetValueFromUserDefaultsIfNothingIsCached() {
        // Given
        let userDefaults = URLUserDefaultsMock()
        let sut = UserDefaultsURLConfiguration(userDefaults: userDefaults)
        userDefaults.set(testUrl, forKey: UserDefaultsURLConfiguration.keyUrl)
        
        // When
        let actualUrl = sut.url
        
        // Then
        XCTAssertEqual(actualUrl, testUrl, "Urls doesn't match")
        XCTAssertEqual(1, userDefaults.urlCallCount, "Url method of user defaults wasn't called")
    }

}
