//
//  CryingEventServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class CryingEventServiceTests: XCTestCase {
    
    //Given
    lazy var sut = CryingEventService(cryingDetectionService: cryingDetectionServiceMock, audioRecordService: audioRecordServiceMock, babiesRepository: cryingEventsRepositoryMock)
    var cryingDetectionServiceMock = CryingDetectionServiceMock()
    var audioRecordServiceMock = AudioRecordServiceMock()
    var cryingEventsRepositoryMock = CryingEventsRepositoryMock()

    override func setUp() {
        cryingDetectionServiceMock = CryingDetectionServiceMock()
        audioRecordServiceMock = AudioRecordServiceMock()
        cryingEventsRepositoryMock = CryingEventsRepositoryMock()
        sut = CryingEventService(cryingDetectionService: cryingDetectionServiceMock, audioRecordService: audioRecordServiceMock, babiesRepository: cryingEventsRepositoryMock)
    }
    
    func testShouldStartCryingDetectionAnalysis() {
        //When
        sut.start()
        
        //Then
        XCTAssertTrue(cryingDetectionServiceMock.analysisStarted)
    }
    
    func testShouldNotStartRecordingAudio() {
        //When
        sut.start()
        
        //Then
        XCTAssertFalse(audioRecordServiceMock.isRecording)
    }
    
    func testShouldStartRecordingAudio() {
        //When
        sut.start()
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        
        //Then
        XCTAssertTrue(audioRecordServiceMock.isRecording)
    }
    
    func testShouldSaveCryingEvent() {
        //When
        sut.start()
        audioRecordServiceMock.isSaveActionSuccess = true
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: false)
        
        //Then
        XCTAssertEqual(cryingEventsRepositoryMock.fetchAllCryingEvents().count, 1)
    }
    
    func testShouldNotSaveCryingEvent() {
        //When
        sut.start()
        audioRecordServiceMock.isSaveActionSuccess = false
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: false)
        
        //Then
        XCTAssertEqual(cryingEventsRepositoryMock.fetchAllCryingEvents().count, 0)
    }
    
    func testShouldNotifyAboutCryingDetecion() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should notify about crying detection")
        sut.cryingEventObservable.subscribe(onNext: { isBabyCrying in
            if isBabyCrying {
                exp.fulfill()
            }
        }).disposed(by: disposeBag)
        
        //When
        sut.start()
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        
        //Then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testShouldNotifyAboutCryingDetectionOnlyOnce() {
        //Given TODO
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        sut.cryingEventObservable
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        //When
        sut.start()
        [0...10].forEach { _ in
            cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        }
        
        //Then
        XCTAssertRecordedElements(observer.events, [true])
    }
    
    func testShouldNotNotifyAboutStoppedCryingDetecionEvent() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should not notify about stopped crying detection")
        sut.cryingEventObservable.subscribe(onNext: { isBabyCrying in
            if !isBabyCrying {
                exp.fulfill()
            }
        }).disposed(by: disposeBag)
        
        //When
        sut.start()
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: false)
        
        //Then
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        XCTAssertTrue(result == .timedOut)
    }
    
    func testShouldNotifyAboutStoppedCryingDetecionEvent() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should notify about crying detection")
        sut.cryingEventObservable.subscribe(onNext: { isBabyCrying in
            if !isBabyCrying {
                exp.fulfill()
            }
        }).disposed(by: disposeBag)
        
        //When
        sut.start()
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: true)
        cryingDetectionServiceMock.notifyAboutCryingDetection(isBabyCrying: false)
        
        //Then
        wait(for: [exp], timeout: 2.0)
    }
}
