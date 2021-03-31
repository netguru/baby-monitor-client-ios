//
//  ServerErrorLogger.swift
//  Baby Monitor
//

import FirebaseCrashlytics

/// Logging error sent to server.
protocol ServerErrorLogger {
    func log(error: Error)
}

final class CrashlyticsErrorLogger: ServerErrorLogger {

    private let service: Crashlytics

    init(crashlyticsService: Crashlytics = Crashlytics.crashlytics()) {
        service = crashlyticsService
    }

    func log(error: Error) {
        service.record(error: error)
    }
}
