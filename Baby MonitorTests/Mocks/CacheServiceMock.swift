//
//  CacheServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class CacheServiceMock: CacheServiceProtocol {
    var selfPushNotificationsToken: String? = ""

    var receiverPushNotificationsToken: String? = ""
}
