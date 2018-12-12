//
//  ServerViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class ServerViewModelTests: XCTestCase {

    func testShouldStartServer() {
        // Given
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)

        // When
        sut.startStreaming()

        // Then
        XCTAssertTrue(netServiceServer.isStarted)
        XCTAssertTrue(messageServer.isStarted)
        XCTAssertTrue(cryingService.isStarted)
    }

    func testPropagateCryingServiceError() {
        // Given
        let exp = expectation(description: "Should call error callback")
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock(shouldThrow: true)
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)
        sut.onAudioRecordServiceError = {
            exp.fulfill()
        }

        // When
        sut.startStreaming()

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testPropagateCryingEventOccurence() {
        // Given
        let exp = expectation(description: "Should call crying event callback")
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)
        sut.onCryingEventOccurence = { result in
            XCTAssertTrue(result)
            exp.fulfill()
        }

        // When
        sut.startStreaming()
        cryingService.cryingEventPublisher.onNext(true)

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testShouldDisconnectServicesAfterDeallocation() {
        // Given
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        var sut: ServerViewModel? = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)

        // When
        sut?.startStreaming()
        sut = nil

        // Then
        XCTAssertFalse(webRtcServerManager.isStarted)
        XCTAssertFalse(messageServer.isStarted)
        XCTAssertFalse(netServiceServer.isStarted)
        XCTAssertFalse(cryingService.isStarted)
    }

    func testShouldSendIceCandidate() {
        // Given
        let webRtcServerManager = WebRtcServerManagerMock()
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "")
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)

        // When
        sut.startStreaming()
        webRtcServerManager.iceCandidatePublisher.onNext(iceCandidate)

        // Then
        XCTAssertEqual([[WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()].jsonString], messageServer.sentMessages)
    }

    func testShouldSendSdpAnswerForSdpOffer() {
        // Given
        let sdpAnswer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "offer")
        let webRtcServerManager = WebRtcServerManagerMock(sdpAnswer: sdpAnswer)
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [AnyMessageDecoder<WebRtcMessage>(SdpOfferDecoderMock(sdpOffer: sdpOffer))], cryingService: cryingService, babiesRepository: babiesRepository)

        // When
        sut.startStreaming()
        messageServer.receivedMessagePublisher.onNext("")

        // Then
        XCTAssertEqual([[WebRtcMessage.Key.answerSDP.rawValue: sdpAnswer.jsonDictionary()].jsonString], messageServer.sentMessages)
        XCTAssertEqual(sdpOffer, webRtcServerManager.remoteSdp as! SessionDescriptionMock)
    }

    func testShouldDispatchIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "")
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoderMock(iceCandidate: iceCandidate))], cryingService: cryingService, babiesRepository: babiesRepository)

        // When
        sut.startStreaming()
        messageServer.receivedMessagePublisher.onNext("")

        // Then
        XCTAssertEqual([iceCandidate], webRtcServerManager.iceCandidates.map { $0 as! IceCandidateMock })
    }

    func testShouldPropagateStream() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStreamProtocol.self)
        let mediaStream = MediaStreamMock(id: "id")
        let webRtcServerManager = WebRtcServerManagerMock()
        let messageServer = MessageServerMock()
        let netServiceServer = NetServiceServerMock()
        let cryingService = CryingEventsServiceMock()
        let babiesRepository = BabiesRepositoryMock()
        let sut = ServerViewModel(webRtcServerManager: webRtcServerManager, messageServer: messageServer, netServiceServer: netServiceServer, decoders: [], cryingService: cryingService, babiesRepository: babiesRepository)
        sut.localStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.startStreaming()
        webRtcServerManager.mediaStreamPublisher.onNext(mediaStream)

        // Then
        XCTAssertEqual([mediaStream], observer.events.map { $0.value.element as! MediaStreamMock })
    }
}
