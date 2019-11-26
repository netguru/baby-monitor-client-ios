import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class ApplicationResetterTests: XCTestCase {
    
    private let resetEventMessage = "{\"action\":\"RESET_KEY\"}"
    
    private var initialAppMode: AppMode!
    private var initialIsSendingCryingsAllowed: Bool!
    private var initialSelfPushNotificationsToken: String!
    private var initialReceiverPushNotificationsToken: String!
    
    private var messageServerMock: MessageServerMock!
    private var eventMessageServiceMock: WebSocketEventMessageServiceMock!
    private var babyModelMock: DatabaseRepositoryMock!
    private var memoryCleanerMock: MemoryCleanerMock!
    private var urlConfigurationMock: URLConfigurationMock!
    private var webSocketWebRtcServiceMock: WebSocketWebRtcServiceMock!
    private var notificationServiceProtocolMock: NotificationServiceProtocolMock!
    private var eventMessageServiceMockWrapper: ClearableLazyItem<WebSocketEventMessageServiceProtocol>!
    private var webSocketWebRtcMockWrapper: ClearableLazyItem<WebSocketWebRtcServiceProtocol>!
    private var bag: DisposeBag!
    
    override func setUp() {
        //  To prevent test overwriting Defaults for the app
        initialAppMode = UserDefaults.appMode
        initialIsSendingCryingsAllowed = UserDefaults.isSendingCryingsAllowed
        initialSelfPushNotificationsToken = UserDefaults.selfPushNotificationsToken
        initialReceiverPushNotificationsToken = UserDefaults.receiverPushNotificationsToken
        
        messageServerMock = MessageServerMock()
        eventMessageServiceMock = WebSocketEventMessageServiceMock()
        babyModelMock = DatabaseRepositoryMock()
        memoryCleanerMock = MemoryCleanerMock()
        urlConfigurationMock = URLConfigurationMock()
        webSocketWebRtcServiceMock = WebSocketWebRtcServiceMock()
        notificationServiceProtocolMock = NotificationServiceProtocolMock()
        eventMessageServiceMockWrapper = ClearableLazyItem(constructor: { return self.eventMessageServiceMock })
        webSocketWebRtcMockWrapper = ClearableLazyItem(constructor: { return self.webSocketWebRtcServiceMock })
        bag = DisposeBag()
    }
    
    func testLocalResetOnParentApp() {
        // Given:
        UserDefaults.appMode = .parent
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeAppResetter()
        sut.localResetCompletionObservable.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: false)
        
        //  Then:
        XCTAssertEqual(eventMessageServiceMock.messages, [resetEventMessage])    // should send reset message to remote client
        XCTAssertEqual(notificationServiceProtocolMock.resetTokensCalled, true)
        XCTAssertEqual(observer.events.count, 1)
        performCommonTests()
    }
    
    func testRemoteResetOnParentApp() {
        // Given:
        UserDefaults.appMode = .parent
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeAppResetter()
        sut.localResetCompletionObservable.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: true)
        
        //  Then:
        XCTAssertEqual(eventMessageServiceMock.messages, [String]())    // should not send reset message
        XCTAssertEqual(notificationServiceProtocolMock.resetTokensCalled, true)
        XCTAssertEqual(observer.events.count, 1)
        performCommonTests()
    }
    
    func testLocalResetOnChildApp() {
        // Given:
        UserDefaults.appMode = .baby
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeAppResetter()
        sut.localResetCompletionObservable.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: false)
        
        //  Then:
        XCTAssertEqual(messageServerMock.sentMessages, [resetEventMessage])    // should send reset message to remote client
        XCTAssertEqual(notificationServiceProtocolMock.resetTokensCalled, false)    // child app does not have tokens to reset
        XCTAssertEqual(observer.events.count, 1)
        performCommonTests()
    }
    
    func testRemoteResetOnChildApp() {
        // Given:
        UserDefaults.appMode = .baby
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let sut = makeAppResetter()
        sut.localResetCompletionObservable.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: true)
        
        //  Then:
        XCTAssertEqual(messageServerMock.sentMessages, [String]())    // should not send reset message
        XCTAssertEqual(notificationServiceProtocolMock.resetTokensCalled, false)    // child app does not have tokens to reset
        XCTAssertEqual(observer.events.count, 1)
        performCommonTests()
    }
    
    override func tearDown() {
        //  Restore initial Defaults values
        UserDefaults.appMode = initialAppMode
        UserDefaults.isSendingCryingsAllowed = initialIsSendingCryingsAllowed
        UserDefaults.selfPushNotificationsToken = initialSelfPushNotificationsToken
        UserDefaults.receiverPushNotificationsToken = initialReceiverPushNotificationsToken
    }
}

private extension ApplicationResetterTests {
    
    func performCommonTests() {
        XCTAssertEqual(UserDefaults.appMode, AppMode.none)
        XCTAssertEqual(UserDefaults.isSendingCryingsAllowed, false)
        XCTAssertEqual(UserDefaults.selfPushNotificationsToken, "")
        XCTAssertNil(UserDefaults.receiverPushNotificationsToken)
        XCTAssertEqual(babyModelMock.baby, Baby.initial)
        XCTAssertEqual(memoryCleanerMock.cleanMemoryCalled, true)
        XCTAssertNil(urlConfigurationMock.url)
        XCTAssertEqual(webSocketWebRtcServiceMock.closeCalled, true)
    }
    
    func makeAppResetter() -> DefaultApplicationResetter {
        return DefaultApplicationResetter(
            messageServer: messageServerMock,
            webSocketEventMessageService: eventMessageServiceMockWrapper,
            babyModelControllerProtocol: babyModelMock,
            memoryCleaner: memoryCleanerMock,
            urlConfiguration: urlConfigurationMock,
            webSocketWebRtcService: webSocketWebRtcMockWrapper,
            localNotificationService: notificationServiceProtocolMock
        )
    }
}
