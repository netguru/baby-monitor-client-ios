//
//  CocoaLumberjackLogger.swift
//  Baby Monitor
//

import CocoaLumberjack

final class CocoaLumberjackLogger: LoggingProtocol {

    init() {
        DDLog.add(DDOSLogger.sharedInstance)
    }

    func log(_ message: String, level: LogLevel) {
        switch level {
        case .info:
            DDLogInfo(message)
        case .debug:
            DDLogDebug(message)
        case .error(let error):
            if let error = error {
                DDLogError(message + error.localizedDescription)
            } else {
                DDLogError(message)
            }
        }
    }
}
