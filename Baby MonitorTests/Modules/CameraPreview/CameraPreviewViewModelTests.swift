//
//  CameraPreviewViewModelTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import RxSwift
import RxTest

class CameraPreviewViewModelTests: XCTestCase {
    
    func testShouldPropagateReceivedStream() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStreamProtocol.self)
        let stream = MediaStreamMock(id: "id")
        let webSocket = WebSocketMock()
        let webRtcClientManager = WebRtcClientManagerMock()
        let cryingEventsRepository = CryingEventsRepositoryMock()
        let babyRepo = BabiesRepositoryMock()
        let babyMonitorEventMessagesDecoder = AnyMessageDecoder<EventMessage>(EventMessageDecoder())
        let websocketService = WebSocketsService(webRtcClientManager: webRtcClientManager, webSocket: webSocket, cryingEventsRepository: cryingEventsRepository, webRtcMessageDecoders: [], babyMonitorEventMessagesDecoder: babyMonitorEventMessagesDecoder)
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, babyRepo: babyRepo)
        
        // When
        websocketService.play()
        sut.remoteStream
            .subscribe(observer)
            .disposed(by: bag)
        webRtcClientManager.mediaStreamPublisher.onNext(stream)
        
        // Then
        XCTAssertEqual([stream], observer.events.map { $0.value.element as! MediaStreamMock })
    }
}
