//
//  DashboardViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class DashboardViewModelTests: XCTestCase {
    
    private var liveCameraTap = PublishSubject<Void>()
    private var addPhotoTap = PublishSubject<Void>()
    private var namePublisher = PublishSubject<String>()
    
    private var bag = DisposeBag()
    
    override func setUp() {
        liveCameraTap = PublishSubject<Void>()
        addPhotoTap = PublishSubject<Void>()
        namePublisher = PublishSubject<String>()
        bag = DisposeBag()
    }

    func testShouldStartConnectionCheckingOnCreation() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        
        // When
        // We assign it to the reference to ensure that it doesn't got deallocated
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        
        // Then
        XCTAssertTrue(connectionChecker.isStarted)
        XCTAssertNotNil(sut)
    }
    
    func testShouldEndConnectionOnDeallocation() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        
        // When
        // And here we don't
        _ = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        
        // Then
        XCTAssertFalse(connectionChecker.isStarted)
    }
    
    func testShouldForwardLiveCameraTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        sut.attachInput(liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
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
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        sut.attachInput(liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
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
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        sut.attachInput(liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
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
        let babiesRepository = DatabaseRepositoryMock(currentBaby: baby)
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        sut.attachInput(liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        babiesRepository.babyUpdateObservable
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        namePublisher.onNext("Franek")
        
        // Then
        XCTAssertEqual(observer.events.count, 2)
    }
    
    func testShouldUpdatePhotoInRepository() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Baby.self)
        let photo = UIImage(named: "add")!
        let baby = Baby(id: "id", name: "name", photo: nil)
        let babiesRepository = DatabaseRepositoryMock(currentBaby: baby)
        let connectionChecker = ConnectionCheckerMock()
        let sut = DashboardViewModel(connectionChecker: connectionChecker, babyModelController: babiesRepository)
        sut.attachInput(liveCameraTap: liveCameraTap, addPhotoTap: addPhotoTap, name: namePublisher)
        babiesRepository.babyUpdateObservable
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        sut.updatePhoto(photo)
        
        // Then
        XCTAssertEqual(observer.events.count, 2)
    }
}
