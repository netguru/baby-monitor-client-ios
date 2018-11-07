//
//  CryingDetectionServiceTests.swift
//  Baby MonitorTests
//


import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class CryingDetectionServiceTests: XCTestCase {
    
    let microphoneTrackerMock = MicrophoneTrackerMock()
    lazy var cryingDetectionService = CryingDetectionService(microphoneTracker: microphoneTrackerMock)
    
    override func tearDown() {
        microphoneTrackerMock.simulatedFrequencyLimit = 2000
        microphoneTrackerMock.simulatedFrequencyStartValue = 0
        microphoneTrackerMock.simulatedReturnedValues = []
        microphoneTrackerMock.stop()
    }
    
    func testShouldDetectCrying() {
        //Given
        microphoneTrackerMock.simulatedFrequencyStartValue = 1100
        let bag = DisposeBag()
        let exp = XCTestExpectation(description: "Should inform about crying detection")
        
        //When
        microphoneTrackerMock.start()
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { _ in
            exp.fulfill()
        })
            .disposed(by: bag)
        
        //Then
        wait(for: [exp], timeout: 5.0)
    }
    
    func testShouldNotDetectCryingAfterTenSeconds() {
        //Given
        microphoneTrackerMock.simulatedReturnedValues = [1200, 1300, 1200, 1400, 1500]
        microphoneTrackerMock.simulatedFrequencyLimit = 1000
        let bag = DisposeBag()
        let exp = expectation(description: "Should not detect crying (i.e. should not fulfill)")
        
        //When
        microphoneTrackerMock.start()
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { _ in
            exp.fulfill()
        })
        .disposed(by: bag)
        let result = XCTWaiter.wait(for: [exp], timeout: 10)
        
        //Then
        XCTAssertTrue(result == .timedOut)
    }
    
    func testShouldDetectCryingTwoTimesAfterSixSeconds() {
        //Given
        microphoneTrackerMock.simulatedFrequencyStartValue = 1100
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let exp = expectation(description: "")
        
        //When
        microphoneTrackerMock.start()
        cryingDetectionService.cryingDetectionObservable.fulfill(expectation: exp, afterEventCount: 2, bag: bag)
        cryingDetectionService.cryingDetectionObservable.subscribe(observer)
            .disposed(by: bag)
        
        //Then
        wait(for: [exp], timeout: 6.0)
    }
}
