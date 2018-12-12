//
//  RealmLullabiesRepositoryTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
import RealmSwift
@testable import BabyMonitor

class RealmLullabiesRepositoryTests: XCTestCase {

    private let config = Realm.Configuration(inMemoryIdentifier: "realm-of-lullabies")
    
    func testShouldSaveLullaby() {
        // Given
        let exp = expectation(description: "Should emit two values")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Lullaby].self)
        let realm = try! Realm(configuration: config)
        let lullaby = Lullaby(name: "test", identifier: "test", type: .yourLullabies)
        let sut = RealmLullabiesRepository(realm: realm)
        sut.lullabies.fulfill(expectation: exp, afterEventCount: 2, bag: bag)
        sut.lullabies.subscribe(observer).disposed(by: bag)
        scheduler.start()
        
        // When
        try! sut.save(lullaby: lullaby)
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertRecordedElements(observer.events, [[], [lullaby]])
        }
    }
    
    func testShouldRemoveSavedLullaby() {
        // Given
        let exp = expectation(description: "Should emit three values")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Lullaby].self)
        let realm = try! Realm(configuration: config)
        let lullaby = Lullaby(name: "test", identifier: "test", type: .yourLullabies)
        let sut = RealmLullabiesRepository(realm: realm)
        sut.lullabies.fulfill(expectation: exp, afterEventCount: 3, bag: bag)
        sut.lullabies.subscribe(observer).disposed(by: bag)
        scheduler.start()
        
        // When
        try! sut.save(lullaby: lullaby)
        try! sut.remove(lullaby: lullaby)
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertRecordedElements(observer.events, [[], [lullaby], []])
        }
    }
    
    func testShouldSaveTwoLullabiesAndUpdateOnEach() {
        // Given
        let exp = expectation(description: "Should emit three values")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Lullaby].self)
        let realm = try! Realm(configuration: config)
        let lullaby = Lullaby(name: "test", identifier: "test", type: .yourLullabies)
        let secondLullaby = Lullaby(name: "second", identifier: "second", type: .yourLullabies)
        let sut = RealmLullabiesRepository(realm: realm)
        sut.lullabies.fulfill(expectation: exp, afterEventCount: 3, bag: bag)
        sut.lullabies.subscribe(observer).disposed(by: bag)
        scheduler.start()
        
        // When
        try! sut.save(lullaby: lullaby)
        try! sut.save(lullaby: secondLullaby)
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertRecordedElements(observer.events, [[], [lullaby], [lullaby, secondLullaby]])
        }
    }
    
    func testShouldUpdateSavedLullaby() {
        // Given
        let exp = expectation(description: "Should emit three values")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Lullaby].self)
        let realm = try! Realm(configuration: config)
        let lullaby = Lullaby(name: "test", identifier: "test", type: .yourLullabies)
        let updatedLullaby = Lullaby(name: "test2", identifier: "test", type: .yourLullabies)
        let sut = RealmLullabiesRepository(realm: realm)
        sut.lullabies.fulfill(expectation: exp, afterEventCount: 3, bag: bag)
        sut.lullabies.subscribe(observer).disposed(by: bag)
        scheduler.start()
        
        // When
        try! sut.save(lullaby: lullaby)
        try! sut.save(lullaby: updatedLullaby)
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertRecordedElements(observer.events, [[], [lullaby], [updatedLullaby]])
        }
    }
    
    func testShouldThrowIfTryingToSaveBMLibraryLullaby() {
        // Given
        let realm = try! Realm(configuration: config)
        let lullaby = Lullaby(name: "test", identifier: "test", type: .bmLibrary)
        let sut = RealmLullabiesRepository(realm: realm)
        
        // When / Then
        XCTAssertThrowsError(try sut.save(lullaby: lullaby)) { error in
            XCTAssertTrue(error == LullabiesRepositoryError.invalidLullabyType)
        }
    }
}
