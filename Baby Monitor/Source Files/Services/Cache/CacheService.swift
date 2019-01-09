//
//  CacheService.swift
//  Baby Monitor
//

import Foundation

protocol CacheServiceProtocol: AnyObject {
    var selfPushNotificationsToken: String? { get set }
    var receiverPushNotificationsToken: String? { get set }
}

final class CacheService: CacheServiceProtocol {
    var selfPushNotificationsToken: String?
    var receiverPushNotificationsToken: String?
}
