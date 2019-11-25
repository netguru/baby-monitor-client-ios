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
    
    private var fakeMessageServer: MessageServerMock!
    private var fakeEventMessageService: WebSocketEventMessageServiceMock!
    private var fakeBabyModel: DatabaseRepositoryMock!
    private var fakeMemoryCleaner: MemoryCleanerMock!
    private var fakeUrlConfiguration: URLConfigurationMock!
    private var fakeWebSocketWebRtcService: WebSocketWebRtcServiceMock!
    private var fakeNotificationServiceProtocol: NotificationServiceProtocolMock!
    private var fakeEventMessageServiceWrapper: ClearableLazyItem<WebSocketEventMessageServiceProtocol>!
    private var fakeWebSocketWebRtcWrapper: ClearableLazyItem<WebSocketWebRtcServiceProtocol>!
    private var bag: DisposeBag!
    
    override func setUp() {
        //  To prevent test overwriting Defaults for the app
        initialAppMode = UserDefaults.appMode
        initialIsSendingCryingsAllowed = UserDefaults.isSendingCryingsAllowed
        initialSelfPushNotificationsToken = UserDefaults.selfPushNotificationsToken
        initialReceiverPushNotificationsToken = UserDefaults.receiverPushNotificationsToken
        
        fakeMessageServer = MessageServerMock()
        fakeEventMessageService = WebSocketEventMessageServiceMock()
        fakeBabyModel = DatabaseRepositoryMock()
        fakeMemoryCleaner = MemoryCleanerMock()
        fakeUrlConfiguration = URLConfigurationMock()
        fakeWebSocketWebRtcService = WebSocketWebRtcServiceMock()
        fakeNotificationServiceProtocol = NotificationServiceProtocolMock()
        fakeEventMessageServiceWrapper = ClearableLazyItem(constructor: { return self.fakeEventMessageService })
        fakeWebSocketWebRtcWrapper = ClearableLazyItem(constructor: { return self.fakeWebSocketWebRtcService })
        bag = DisposeBag()
    }
    
    func testLocalResetOnParentApp() {
        // Given:
        UserDefaults.appMode = .parent
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let sut = makeAppResetter()
        sut.localResetCompleted.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: false)
        
        //  Then:
        XCTAssertEqual(fakeEventMessageService.messages, [resetEventMessage])    // should send reset message to remote client
        XCTAssertEqual(fakeNotificationServiceProtocol.resetTokensCalled, true)
        XCTAssertRecordedElements(observer.events, [false, true])               // should emit value once reset started and finished
        performCommonTests()
    }
    
    func testRemoteResetOnParentApp() {
        // Given:
        UserDefaults.appMode = .parent
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let sut = makeAppResetter()
        sut.localResetCompleted.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: true)
        
        //  Then:
        XCTAssertEqual(fakeEventMessageService.messages, [String]())    // should not send reset message
        XCTAssertEqual(fakeNotificationServiceProtocol.resetTokensCalled, true)
        XCTAssertRecordedElements(observer.events, [false, true])               // should emit value once reset started and finished
        performCommonTests()
    }
    
    func testLocalResetOnChildApp() {
        // Given:
        UserDefaults.appMode = .baby
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let sut = makeAppResetter()
        sut.localResetCompleted.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: false)
        
        //  Then:
        XCTAssertEqual(fakeMessageServer.sentMessages, [resetEventMessage])    // should send reset message to remote client
        XCTAssertEqual(fakeNotificationServiceProtocol.resetTokensCalled, false)    // child app does not have tokens to reset
        XCTAssertRecordedElements(observer.events, [false, true])               // should emit value once reset started and finished
        performCommonTests()
    }
    
    func testRemoteResetOnChildApp() {
        // Given:
        UserDefaults.appMode = .baby
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let sut = makeAppResetter()
        sut.localResetCompleted.subscribe(observer).disposed(by: bag)
        
        //  When:
        sut.reset(isRemote: true)
        
        //  Then:
        XCTAssertEqual(fakeMessageServer.sentMessages, [String]())    // should not send reset message
        XCTAssertEqual(fakeNotificationServiceProtocol.resetTokensCalled, false)    // child app does not have tokens to reset
        XCTAssertRecordedElements(observer.events, [false, true])               // should emit value once reset started and finished
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
        XCTAssertEqual(fakeBabyModel.baby, Baby.initial)
        XCTAssertEqual(fakeMemoryCleaner.cleanMemoryCalled, true)
        XCTAssertNil(fakeUrlConfiguration.url)
        XCTAssertEqual(fakeWebSocketWebRtcService.closeCalled, true)
    }
    
    func makeAppResetter() -> DefaultApplicationResetter {
        return DefaultApplicationResetter(
            messageServer: fakeMessageServer,
            webSocketEventMessageService: fakeEventMessageServiceWrapper,
            babyModelControllerProtocol: fakeBabyModel,
            memoryCleaner: fakeMemoryCleaner,
            urlConfiguration: fakeUrlConfiguration,
            webSocketWebRtcService: fakeWebSocketWebRtcWrapper,
            localNotificationService: fakeNotificationServiceProtocol
        )
    }
}
