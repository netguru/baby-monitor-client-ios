//
//  Logger.swift
//  Baby Monitor
//

enum Logger {

    private static let defaultLogger: LoggingProtocol = SwiftyBeaverLogger.shared

    static func debug(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        defaultLogger.log(message, level: .debug, file, function, line: line)
    }

    static func info(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        defaultLogger.log(message, level: .info, file, function, line: line)
    }

    static func warning(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        defaultLogger.log(message, level: .warning, file, function, line: line)
    }

    static func error(_ message: String, error: Error? = nil, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        defaultLogger.log(message, level: .error(error), file, function, line: line)
    }
}
