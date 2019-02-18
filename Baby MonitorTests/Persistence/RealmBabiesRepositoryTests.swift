//
//  BabiesRepositoryTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import RealmSwift
import RxSwift

class RealmBabiesRepositoryTests: XCTestCase {
    
    private let config = Realm.Configuration(inMemoryIdentifier: "realm-of-babies")
    
    func testShouldFetchInitialBaby() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        
        // When
        let baby = sut.baby
        
        // Then
        XCTAssertTrue(baby.id == Baby.initial.id)
    }
}
