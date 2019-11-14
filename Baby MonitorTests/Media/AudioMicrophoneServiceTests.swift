//
//  AudioRecordServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
@testable import BabyMonitor

class AudioMicrophoneServiceTests: XCTestCase {
    
    //Given
    lazy var recorderMock = MicrophoneRecordMock()
    lazy var capturerMock = MicrophoneCaptureMock()
    lazy var microphoneMock = AudioKitMicrophoneMock(record: recorderMock, capture: capturerMock)

    lazy var sut = try! AudioMicrophoneService(microphoneFactory: {
        return microphoneMock
    })
    
    override func setUp() {
        sut = try! AudioMicrophoneService(microphoneFactory: {
            return microphoneMock
        })
    }

    func testShouldStartRecording() {
        //When
        sut.startRecording()
        
        //Then
        XCTAssertTrue(recorderMock.isRecordReset)
        XCTAssertTrue(recorderMock.isRecording)
    }
    
    func testShouldStopRecording() {
        //When
        sut.startRecording()
        recorderMock.isRecording = true
        sut.stopRecording()
        
        //Then
        XCTAssertFalse(recorderMock.isRecording)
    }
    
    func testShouldPublishAudioFile() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should publish audio file")
        sut.directoryDocumentsSavableObservable.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        recorderMock.shouldReturnNilForAudioFile = false
        
        //When
        sut.startRecording()
        sut.stopRecording()
        
        //Then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testShouldNotPublishAudioFile() {
        //Given
        let disposeBag = DisposeBag()
        let exp = expectation(description: "Should not publish audio file")
        sut.directoryDocumentsSavableObservable.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        recorderMock.shouldReturnNilForAudioFile = true
        
        //When
        sut.stopRecording()
        
        //Then
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        XCTAssertTrue(result == .timedOut)
    }
}
