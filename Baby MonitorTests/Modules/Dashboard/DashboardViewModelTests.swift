//
//  DashboardViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class DashboardViewModelTests: XCTestCase {
    
    private var switchBabyTap = PublishSubject<Void>()
    private var liveCameraTap = PublishSubject<Void>()
    private var addPhotoTap = PublishSubject<Void>()
    private var namePublisher = PublishSubject<String>()
    
    private let bag = DisposeBag()
    
    override func setUp() {
        switchBabyTap = PublishSubject<Void>()
        liveCameraTap = PublishSubject<Void>()
        addPhotoTap = PublishSubject<Void>()
        namePublisher = PublishSubject<String>()
    }

    func testShouldStartConnectionCheckingOnCreation() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        
        // When
        // We assign it to the reference to ensure that it doesn't got deallocated
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        
        // Then
        XCTAssertTrue(connectionChecker.isStarted)
        XCTAssertNotNil(sut)
    }
    
    func testShouldEndConnectionOnDeallocation() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        
        // When
        // And here we don't
        _ = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        
        // Then
        XCTAssertFalse(connectionChecker.isStarted)
    }
    
    func testShouldForwardSwitchBabyTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        sut.showBabies?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        switchBabyTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldForwardLiveCameraTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        sut.liveCameraPreview?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        liveCameraTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldForwardAddPhotoTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        sut.addPhoto?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        addPhotoTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldForwardDismissImagePickerTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        sut.dismissImagePicker
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        sut.selectDismissImagePicker()
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldUpdateNameInRepository() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Baby.self)
        let baby = Baby(id: "id", name: "name", photo: nil)
        let changedBaby = Baby(id: "id", name: "Changed name", photo: nil)
        let babiesRepository = BabiesRepositoryMock(currentBaby: baby)
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        babiesRepository.babyUpdateObservable
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        namePublisher.onNext(changedBaby.name)
        
        // Then
        XCTAssertRecordedElements(observer.events, [baby, changedBaby])
    }
    
    func testShouldUpdatePhotoInRepository() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Baby.self)
        let photo = UIImage(named: "add")!
        let baby = Baby(id: "id", name: "name", photo: nil)
        let changedBaby = Baby(id: "id", name: "name", photo: photo)
        let babiesRepository = BabiesRepositoryMock(currentBaby: baby)
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyRepo: babiesRepository)
        sut.attachInput(switchBabyTap: switchBabyTap, liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        babiesRepository.babyUpdateObservable
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        sut.updatePhoto(photo)
        
        // Then
        XCTAssertRecordedElements(observer.events, [baby, changedBaby])
    }
}
