//
//  BabiesRepositoryTests.swift
//  Baby MonitorTests
//


import XCTest
import RealmSwift
@testable import BabyMonitor

class RealmBabiesRepositoryTests: XCTestCase {
    
    private let config = Realm.Configuration(inMemoryIdentifier: "realm-of-babies")
    
    func testShouldSaveBaby() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(name: "test")
        
        // When
        try! sut.save(baby: baby)
        
        // Then
        let results = realm.objects(RealmBaby.self)
            .filter { $0.id == baby.id }
        XCTAssertEqual(1, results.count, "The result size isn't proper")
        XCTAssertEqual(baby.id, results[0].id, "The result id doesn't match")
    }
    
    func testShouldSaveNewBabyInPlaceOfOld() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(id: "1", name: "test1")
        let newBaby = Baby(id: "1", name: "test2")
        
        // When
        try! sut.save(baby: baby)
        try! sut.save(baby: newBaby)
        
        // Then
        let results = realm.objects(RealmBaby.self)
            .filter { $0.id == baby.id }
        XCTAssertEqual(1, results.count, "The result size isn't proper")
        XCTAssertEqual(newBaby.id, results[0].id, "The result id doesn't match")
        XCTAssertEqual(newBaby.name, results[0].name, "The result name doesn't match")
    }
    
    func testShouldFetchEmptyArrayForEmptyRepository() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        
        // When
        let results = sut.fetchAllBabies()
        
        // Then
        XCTAssertTrue(results.isEmpty)
    }
    
    func testShouldFetchSavedBaby() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(name: "test1")
        try! realm.write {
            realm.add(RealmBaby(with: baby))
        }
        
        // When
        let results = sut.fetchAllBabies()
        
        // Then
        XCTAssertEqual(1, results.count, "The result size isn't proper")
        XCTAssertEqual(baby, results[0], "The babies doesn't match")
    }
    
    func testShouldFetchNilForNonexistentBabyId() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(id: "1", name: "test1")
        try! realm.write {
            realm.add(RealmBaby(with: baby))
        }
        
        // When
        let result = sut.fetchBaby(id: "2")
        
        // Then
        XCTAssertNil(result)
    }
    
    func testShouldFetchBabyWithSpecifiedId() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(id: "1", name: "test1")
        try! realm.write {
            realm.add(RealmBaby(with: baby))
        }
        
        // When
        let result = sut.fetchBaby(id: "1")
        
        // Then
        XCTAssertEqual(baby, result)
    }

    func testShouldFetchEmptyArrayForNonexistentBabyName() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let baby = Baby(id: "1", name: "test2")
        try! realm.write {
            realm.add(RealmBaby(with: baby))
        }
        
        // When
        let results = sut.fetchBabies(name: "test1")
        
        // Then
        XCTAssertTrue(results.isEmpty)
    }
    
    func testShouldFetchBabiesWithSpecifiedName() {
        // Given
        let realm = try! Realm(configuration: config)
        let sut = RealmBabiesRepository(realm: realm)
        let name = "test1"
        let baby = Baby(id: "1", name: name)
        let secondBaby = Baby(id: "2", name: name)
        try! realm.write {
            realm.add(RealmBaby(with: baby))
            realm.add(RealmBaby(with: secondBaby))
        }
        
        // When
        let results = sut.fetchBabies(name: name)
        
        // Then
        XCTAssertEqual(2, results.count, "The results count doesn't match")
        results.forEach {
            XCTAssertEqual(name, $0.name, "The baby with id: \($0.id) has different name: \($0.name)")
        }
    }
}
