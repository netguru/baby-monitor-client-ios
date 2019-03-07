//
//  URLConfigurationMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class URLConfigurationMock: URLConfiguration {
    var url: URL?
    init(url: URL? = nil) {
        self.url = url
    }
}
