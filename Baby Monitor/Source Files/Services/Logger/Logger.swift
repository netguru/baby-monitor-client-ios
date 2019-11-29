//
//  Logger.swift
//  Baby Monitor
//

enum Logger {

    private static let defaultLogger: LoggingProtocol = SwiftyBeaverLogger.shared

    static func debug(_ message: String) {
        defaultLogger.log(message, level: .debug)
    }

    static func info(_ message: String) {
        defaultLogger.log(message, level: .info)
    }

    static func warning(_ message: String) {
        defaultLogger.log(message, level: .warning)
    }

    static func error(_ message: String, error: Error? = nil) {
        defaultLogger.log(message, level: .error(error))
    }
}
