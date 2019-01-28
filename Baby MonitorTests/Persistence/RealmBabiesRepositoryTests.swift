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
    
    func testShouldNotifyObserverAboutBabyNameChange() {
        //Given
        let disposeBag = DisposeBag()
        let realm = try! Realm(configuration: config)
        let exp = expectation(description: "Should update baby name")
        let sut = RealmBabiesRepository(realm: realm)
        var changedBabyName: String?
        sut.babyUpdateObservable.skip(1).subscribe(
            onNext: {
                exp.fulfill()
                changedBabyName = $0.name
            }
            )
        .disposed(by: disposeBag)

        //When
        sut.updateName("Adrian")

        //Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(changedBabyName! == "Adrian")
        }
    }

    func testShouldNotifyObserverAboutBabyPhotoChange() {
        //Given
        let disposeBag = DisposeBag()
        let realm = try! Realm(configuration: config)
        let exp = expectation(description: "Should update baby photo")
        let sut = RealmBabiesRepository(realm: realm)
        let imageToSave = UIImage(data: #imageLiteral(resourceName: "arrowUp").jpegData(compressionQuality: 1)!)!
        var changedBabyImage: UIImage?
        sut.babyUpdateObservable.skip(1).subscribe(
            onNext: {
                exp.fulfill()
                changedBabyImage = $0.photo
            }
            )
            .disposed(by: disposeBag)

        //When
        sut.updatePhoto(imageToSave)

        //Then
        waitForExpectations(timeout: 0.1) { _ in
            let firstImageData = imageToSave.jpegData(compressionQuality: 1)!
            let secondImageData = changedBabyImage!.jpegData(compressionQuality: 1)!
            XCTAssertEqual(firstImageData, secondImageData)
        }

    }
}
