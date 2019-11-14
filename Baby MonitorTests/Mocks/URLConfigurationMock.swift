//
//  URLConfigurationMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import Foundation

final class URLConfigurationMock: URLConfiguration {
    var url: URL?
    init(url: URL? = nil) {
        self.url = url
    }
}
