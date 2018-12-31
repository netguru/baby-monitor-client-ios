//
//  CacheService.swift
//  Baby Monitor
//

import Foundation

protocol CacheServiceProtocol: AnyObject {
    var pushNotificationsToken: String? { get set }
}

final class CacheService: CacheServiceProtocol {
    var pushNotificationsToken: String?
}
