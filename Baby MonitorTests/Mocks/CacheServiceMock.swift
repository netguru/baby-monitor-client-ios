//
//  CacheServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import Foundation

final class CacheServiceMock: CacheServiceProtocol {
    var selfPushNotificationsToken: String? = ""
    var receiverPushNotificationsToken: String? = ""
}
