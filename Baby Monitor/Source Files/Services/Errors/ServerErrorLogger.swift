//
//  ServerErrorLogger.swift
//  Baby Monitor
//

import Crashlytics

/// Logging error sent to server.
protocol ServerErrorLogger {
    func log(error: Error)
    func log(error: Error, additionalInfo: [String: Any])
}

final class CrashlyticsErrorLogger: ServerErrorLogger {

    private let service: Crashlytics

    init(crashlyticsService: Crashlytics = Crashlytics.sharedInstance()) {
        service = crashlyticsService
    }

    func log(error: Error) {
        service.recordError(error)
    }

    func log(error: Error, additionalInfo: [String: Any]) {
        service.recordError(error, withAdditionalUserInfo: additionalInfo)
    }
}
