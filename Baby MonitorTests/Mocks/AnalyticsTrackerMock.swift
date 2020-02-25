//
//  AnalyticsTrackerMock.swift
//  Baby MonitorTests

@testable import BabyMonitor

final class AnalyticsTrackerMock: AnalyticsProtocol {

    var screenLogged = false
    var eventLogged = false
    var userPropertyLogged = false

    func logScreen(name: String, className: String) {
        screenLogged = true
    }

    func logEvent(_ eventName: String, parameters: [String: Any]?) {
        eventLogged = true
    }

    func setUserProperty(_ value: String?, forName name: String) {
        userPropertyLogged = true
    }
}
