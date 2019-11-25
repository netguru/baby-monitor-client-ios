import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class SocketCommunicationManagerTests: XCTestCase {
    
    private var fakeEventMessageService: WebSocketEventMessageServiceMock!
    private var fakeWebSocketWebRtcService: WebSocketWebRtcServiceMock!
    private var fakeWebSocket: WebSocketMock!
    private var fakeEventMessageServiceWrapper: ClearableLazyItem<WebSocketEventMessageServiceProtocol>!
    private var fakeWebSocketWebRtcWrapper: ClearableLazyItem<WebSocketWebRtcServiceProtocol>!
    private var fakeWebSocketWrapper: ClearableLazyItem<WebSocketProtocol?>!
    private var bag: DisposeBag!
    
    override func setUp() {
        fakeEventMessageService = WebSocketEventMessageServiceMock()
        fakeWebSocketWebRtcService = WebSocketWebRtcServiceMock()
        fakeWebSocket = WebSocketMock()
        fakeEventMessageServiceWrapper = ClearableLazyItem(constructor: { return self.fakeEventMessageService })
        fakeWebSocketWebRtcWrapper = ClearableLazyItem(constructor: { return self.fakeWebSocketWebRtcService })
        fakeWebSocketWrapper = ClearableLazyItem(constructor: { return self.fakeWebSocket })
        bag = DisposeBag()
    }
    
    func testTerminatingCommunication() {
        // Given:
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeCommunicationManager()
        sut.communicationTerminated.subscribe(observer).disposed(by: bag)
    
        //  When:
        sut.terminate()
        
        //  Then:
        XCTAssertEqual(fakeEventMessageServiceWrapper.isCleared, true)
        XCTAssertEqual(fakeWebSocketWebRtcWrapper.isCleared, true)
        XCTAssertEqual(fakeWebSocketWrapper.isCleared, true)
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testResettingCommunication() {
        // Given:
        let scheduler = TestScheduler(initialClock: 0)
        let terminationObserver = scheduler.createObserver(Void.self)
        let resetObserver = scheduler.createObserver(Void.self)
        let sut = makeCommunicationManager()
        sut.communicationTerminated.subscribe(terminationObserver).disposed(by: bag)
        sut.communicationResetted.subscribe(resetObserver).disposed(by: bag)
        
        //  When:
        sut.reset()
        
        //  Then:
        XCTAssertEqual(fakeEventMessageServiceWrapper.isCleared, false)
        XCTAssertEqual(fakeWebSocketWebRtcWrapper.isCleared, false)
        XCTAssertEqual(terminationObserver.events.count, 1)
        XCTAssertEqual(resetObserver.events.count, 1)
    }
    
    override func tearDown() {
        fakeEventMessageServiceWrapper.clear()
        fakeWebSocketWebRtcWrapper.clear()
        fakeWebSocketWrapper.clear()
    }
}

private extension SocketCommunicationManagerTests {
    
    func makeCommunicationManager() -> DefaultSocketCommunicationManager {
        return DefaultSocketCommunicationManager(
            webSocketEventMessageService: fakeEventMessageServiceWrapper,
            webSocketWebRtcService: fakeWebSocketWebRtcWrapper,
            webSocket: fakeWebSocketWrapper)
    }
}
