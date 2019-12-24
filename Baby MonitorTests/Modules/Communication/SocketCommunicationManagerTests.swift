import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class SocketCommunicationManagerTests: XCTestCase {
    
    private var eventMessageServiceMock: WebSocketEventMessageServiceMock!
    private var webSocketWebRtcServiceMock: WebSocketWebRtcServiceMock!
    private var webSocketMock: WebSocketMock!
    private var eventMessageServiceMockWrapper: WebSocketEventMessageServiceProtocol!
    private var webSocketWebRtcMockWrapper: ClearableLazyItem<WebSocketWebRtcServiceProtocol>!
    private var webSocketMockWrapper: ClearableLazyItem<WebSocketProtocol?>!
    private var bag: DisposeBag!
    
    override func setUp() {
        eventMessageServiceMock = WebSocketEventMessageServiceMock()
        webSocketWebRtcServiceMock = WebSocketWebRtcServiceMock()
        webSocketMock = WebSocketMock()
        webSocketWebRtcMockWrapper = ClearableLazyItem(constructor: { return self.webSocketWebRtcServiceMock })
        webSocketMockWrapper = ClearableLazyItem(constructor: { return self.webSocketMock })
        bag = DisposeBag()
    }
    
    func testTerminatingCommunication() {
        // Given:
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeCommunicationManager()
        sut.communicationTerminationObservable.subscribe(observer).disposed(by: bag)
    
        //  When:
        sut.terminate()
        
        //  Then:
        XCTAssertEqual(webSocketWebRtcMockWrapper.isCleared, true)
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testResettingCommunication() {
        // Given:
        let scheduler = TestScheduler(initialClock: 0)
        let terminationObserver = scheduler.createObserver(Void.self)
        let resetObserver = scheduler.createObserver(Void.self)
        let sut = makeCommunicationManager()
        sut.communicationTerminationObservable.subscribe(terminationObserver).disposed(by: bag)
        sut.communicationResetObservable.subscribe(resetObserver).disposed(by: bag)
        
        //  When:
        sut.reset()
        
        //  Then:
        XCTAssertEqual(webSocketWebRtcMockWrapper.isCleared, false)
        XCTAssertEqual(terminationObserver.events.count, 1)
        XCTAssertEqual(resetObserver.events.count, 1)
    }
    
    override func tearDown() {
        webSocketWebRtcMockWrapper.clear()
        webSocketMockWrapper.clear()
    }
}

private extension SocketCommunicationManagerTests {
    
    func makeCommunicationManager() -> DefaultSocketCommunicationManager {
        return DefaultSocketCommunicationManager(
            webSocketEventMessageService: eventMessageServiceMock,
            webSocketWebRtcService: webSocketWebRtcMockWrapper,
            webSocket: webSocketMockWrapper)
    }
}
