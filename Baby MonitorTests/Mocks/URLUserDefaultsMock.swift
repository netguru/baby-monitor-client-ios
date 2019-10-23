//
//  URLUserDefaultsMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import Foundation

final class URLUserDefaultsMock: URLUserDefaults {
    private var dict: [String: URL] = [:]
    
    var urlCallCount: Int = 0
    
    func url(forKey: String) -> URL? {
        urlCallCount += 1
        return dict[forKey]
    }
    
    func set(_ url: URL?, forKey: String) {
        dict[forKey] = url
    }
        
}
