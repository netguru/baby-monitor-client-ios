//
//  CryingDetectionServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class CryingDetectionServiceTests: XCTestCase {
    
    let audioMicrophoneServiceMock = AudioMicrophoneServiceMock()
    lazy var cryingDetectionService = CryingDetectionService(microphoneCaptureService: audioMicrophoneServiceMock)
    
//    override func tearDown() {
//        microphoneTrackerMock.simulatedFrequencyLimit = 2000
//        microphoneTrackerMock.simulatedFrequencyStartValue = 0
//        microphoneTrackerMock.simulatedReturnedValues = []
//        microphoneTrackerMock.stop()
//    }

//    func testShouldDetectCrying() {
//        //Given
//        microphoneTrackerMock.simulatedFrequencyStartValue = 1100
//        let bag = DisposeBag()
//        let exp = XCTestExpectation(description: "Should inform about crying detection")
//
//        //When
//        microphoneTrackerMock.start()
//        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { _ in
//            exp.fulfill()
//        })
//            .disposed(by: bag)
//
//        //Then
//        wait(for: [exp], timeout: 10.0)
//    }

//    func testShouldNotDetectCryingAfterTenSeconds() {
//        //Given
//        microphoneTrackerMock.simulatedReturnedValues = [1200, 1300, 1200, 1400, 1500]
//        microphoneTrackerMock.simulatedFrequencyLimit = 1000
//        let bag = DisposeBag()
//        let exp = expectation(description: "Should not detect crying (i.e. should not fulfill)")
//
//        //When
//        microphoneTrackerMock.start()
//        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { isBabyCrying in
//            if isBabyCrying {
//                exp.fulfill()
//            }
//        }).disposed(by: bag)
//        let result = XCTWaiter.wait(for: [exp], timeout: 10)
//
//        //Then
//        XCTAssertTrue(result == .timedOut)
//    }

//    func testShouldNotifyAboutCryingDetectionOnlyOnce() {
//        //Given
//        microphoneTrackerMock.simulatedFrequencyStartValue = 1100
//        let bag = DisposeBag()
//        let scheduler = TestScheduler(initialClock: 0)
//        let observer = scheduler.createObserver(Bool.self)
//        let exp = expectation(description: "")
//
//        //When
//        microphoneTrackerMock.start()
//        cryingDetectionService.cryingDetectionObservable.fulfill(expectation: exp, afterEventCount: 2, bag: bag)
//        cryingDetectionService.cryingDetectionObservable.subscribe(observer).disposed(by: bag)
//
//        //Then
//        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
//        XCTAssertTrue(result == .timedOut)
//        XCTAssertTrue(observer.events.map { $0.value.element! } == [true])
//    }

//    func testShouldNotifyAboutCryingDetectionTwoTimes() {
//        //Given
//        for _ in 0...9 { microphoneTrackerMock.simulatedReturnedValues.append(1100) }
//        for _ in 0...49 { microphoneTrackerMock.simulatedReturnedValues.append(900) }
//        for _ in 0...9 { microphoneTrackerMock.simulatedReturnedValues.append(1100) }
//        let bag = DisposeBag()
//        let scheduler = TestScheduler(initialClock: 0)
//        let observer = scheduler.createObserver(Bool.self)
//        let exp = expectation(description: "")
//
//        //When
//        microphoneTrackerMock.start()
//        cryingDetectionService.cryingDetectionObservable.fulfill(expectation: exp, afterEventCount: 3, bag: bag)
//        cryingDetectionService.cryingDetectionObservable.subscribe(observer).disposed(by: bag)
//
//        //Then
//        wait(for: [exp], timeout: 20.0)
//        XCTAssertTrue(observer.events.map { $0.value.element! } == [true, false, true])
//    }
}
