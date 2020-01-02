//
//  NetServiceConnectionCheckerTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class NetServiceConnectionCheckerTests: XCTestCase {

    enum NetServiceConnectionCheckerAction {
        case start
        case stop
    }

    func performStatusTest(producedActions: [Recorded<Event<NetServiceConnectionCheckerAction>>], producedServices: [Recorded<Event<[NetServiceDescriptor]>>], expectedStatuses: [Recorded<Event<ConnectionStatus>>], file: StaticString = #file, line: UInt = #line) {

        let scheduler = TestScheduler(initialClock: 0)
        let bag = DisposeBag()

        let client = NetServiceClientMock()
        let urlConfiguration = URLConfigurationMock(url: URL(string: "ws://ip:port"))
        let sut = NetServiceConnectionChecker(netServiceClient: client, urlConfiguration: urlConfiguration)

        let services = scheduler.createHotObservable(producedServices)
        let actions = scheduler.createColdObservable(producedActions)
        let statuses = scheduler.createObserver(ConnectionStatus.self)

        services.bind(to: client.servicesRelay).disposed(by: bag)
        actions.subscribe(onNext: { [unowned sut] in $0 == .start ? sut.start() : sut.stop() }).disposed(by: bag)
        sut.connectionStatus.subscribe(statuses).disposed(by: bag)

        scheduler.start()

        XCTAssertEqual(statuses.events, expectedStatuses, file: file, line: line)

    }

    func testShouldEnableClientWhenStarted() {

        let client = NetServiceClientMock()
        let urlConfiguration = URLConfigurationMock(url: URL(string: "ws://ip:port"))
        let sut = NetServiceConnectionChecker(netServiceClient: client, urlConfiguration: urlConfiguration)

        client.isEnabled.value = false
        sut.start()

        XCTAssertTrue(client.isEnabled.value)

    }

    func testShouldDisableClientWhenStopped() {

        let client = NetServiceClientMock()
        let urlConfiguration = URLConfigurationMock(url: URL(string: "ws://ip:port"))
        let sut = NetServiceConnectionChecker(netServiceClient: client, urlConfiguration: urlConfiguration)

        client.isEnabled.value = true
        sut.stop()

        XCTAssertFalse(client.isEnabled.value)

    }

    func testShouldHaveInitialStatusOfDisconnectedWhenClientIsNotStarted() {
        performStatusTest(
            producedActions: [
                // no actions
            ],
            producedServices: [
                // no services
            ],
            expectedStatuses: [
                .next(0, .disconnected)
            ]
        )
    }

    func testShouldNotChangeStatusWhenClientIsNotStarted() {
        performStatusTest(
            producedActions: [
                // no actions
            ],
            producedServices: [
                .next(1, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")])
            ],
            expectedStatuses: [
                .next(0, .disconnected)
            ]
        )
    }

    func testShouldChangeStatusToConnectedWhenServiceIsFound() {
        performStatusTest(
            producedActions: [
                .next(1, .start)
            ],
            producedServices: [
                .next(2, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")])
            ],
            expectedStatuses: [
                .next(0, .disconnected),
                .next(2, .connected)
            ]
        )
    }

    func testShouldChangeStatusToDisconnectedWhenServiceIsLost() {
        performStatusTest(
            producedActions: [
                .next(1, .start)
            ],
            producedServices: [
                .next(2, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")]),
                .next(3, [])
            ],
            expectedStatuses: [
                .next(0, .disconnected),
                .next(2, .connected),
                .next(3, .disconnected)
            ]
        )
    }

    func testShouldChangeStatusToDisconnectedIfClientIsStopped() {
        performStatusTest(
            producedActions: [
                .next(1, .start),
                .next(3, .stop)
            ],
            producedServices: [
                .next(2, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")])
            ],
            expectedStatuses: [
                .next(0, .disconnected),
                .next(2, .connected),
                .next(3, .disconnected)
            ]
        )
    }

    func testShouldNotChangeStatusTwice() {
        performStatusTest(
            producedActions: [
                .next(1, .start)
            ],
            producedServices: [
                .next(2, []),
                .next(3, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")]),
                .next(4, [NetServiceDescriptor(name: "Device", ip: "0.0.0.0", port: "0")]),
                .next(5, []),
                .next(6, [])
            ],
            expectedStatuses: [
                .next(0, .disconnected),
                .next(3, .connected),
                .next(5, .disconnected)
            ]
        )
    }

}
