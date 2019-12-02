//
//  DashboardViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class DashboardViewModelTests: XCTestCase {
    
    private var liveCameraTap = PublishSubject<Void>()
    private var activityLogTap = PublishSubject<Void>()
    private var settingsTap = PublishSubject<Void>()
    
    private var bag = DisposeBag()
    
    override func setUp() {
        liveCameraTap = PublishSubject<Void>()
        activityLogTap = PublishSubject<Void>()
        settingsTap = PublishSubject<Void>()
        bag = DisposeBag()
    }

    func testShouldStartConnectionCheckingOnCreation() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let webSocketEventMessageServiceMockWrapper = ClearableLazyItem<WebSocketEventMessageServiceProtocol>(constructor: {
            return webSocketEventMessageServiceMock
        })
        let microphonePermissionProviderMock = MicrophonePermissionProviderMock()
        let socketCommunicationManagerMock = SocketCommunicationManagerMock()
        
        // When
        // We assign it to the reference to ensure that it doesn't got deallocated
        let sut = DashboardViewModel(networkDiscoveryConnectionStateProvider: connectionChecker, socketCommunicationManager: socketCommunicationManagerMock, babyModelController: babiesRepository, webSocketEventMessageService: webSocketEventMessageServiceMockWrapper, microphonePermissionProvider: microphonePermissionProviderMock)
        
        // Then
        XCTAssertTrue(connectionChecker.isStarted)
        XCTAssertNotNil(sut)
    }
    
    func testShouldEndConnectionOnDeallocation() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let webSocketEventMessageServiceMockWrapper = ClearableLazyItem<WebSocketEventMessageServiceProtocol>(constructor: {
            return webSocketEventMessageServiceMock
        })
        let microphonePermissionProviderMock = MicrophonePermissionProviderMock()
        let socketCommunicationManagerMock = SocketCommunicationManagerMock()
        
        // When
        // And here we don't
        _ = DashboardViewModel(networkDiscoveryConnectionStateProvider: connectionChecker, socketCommunicationManager: socketCommunicationManagerMock, babyModelController: babiesRepository, webSocketEventMessageService: webSocketEventMessageServiceMockWrapper, microphonePermissionProvider: microphonePermissionProviderMock)
        
        // Then
        XCTAssertFalse(connectionChecker.isStarted)
    }
    
    func testShouldForwardLiveCameraTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let webSocketEventMessageServiceMockWrapper = ClearableLazyItem<WebSocketEventMessageServiceProtocol>(constructor: {
            return webSocketEventMessageServiceMock
        })
        let microphonePermissionProviderMock = MicrophonePermissionProviderMock()
        let socketCommunicationManagerMock = SocketCommunicationManagerMock()
        let sut = DashboardViewModel(networkDiscoveryConnectionStateProvider: connectionChecker, socketCommunicationManager: socketCommunicationManagerMock, babyModelController: babiesRepository, webSocketEventMessageService: webSocketEventMessageServiceMockWrapper, microphonePermissionProvider: microphonePermissionProviderMock)
        sut.attachInput(liveCameraTap: liveCameraTap, activityLogTap: activityLogTap, settingsTap: settingsTap)
        sut.liveCameraPreview?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        liveCameraTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldForwardActivityLogTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = DatabaseRepositoryMock()
        let connectionChecker = ConnectionCheckerMock()
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let webSocketEventMessageServiceMockWrapper = ClearableLazyItem<WebSocketEventMessageServiceProtocol>(constructor: {
            return webSocketEventMessageServiceMock
        })
        let microphonePermissionProviderMock = MicrophonePermissionProviderMock()
        let socketCommunicationManagerMock = SocketCommunicationManagerMock()
        let sut = DashboardViewModel(networkDiscoveryConnectionStateProvider: connectionChecker, socketCommunicationManager: socketCommunicationManagerMock, babyModelController: babiesRepository, webSocketEventMessageService: webSocketEventMessageServiceMockWrapper, microphonePermissionProvider: microphonePermissionProviderMock)
        sut.attachInput(liveCameraTap: liveCameraTap, activityLogTap: activityLogTap, settingsTap: settingsTap)
        sut.activityLogTap?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        activityLogTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }}
