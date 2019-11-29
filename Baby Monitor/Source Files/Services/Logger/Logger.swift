//
//  Logger.swift
//  Baby Monitor
//

final class Logger: LoggingProtocol {

    static let shared = Logger(with: CocoaLumberjackLogger())

    private let defaultLogger: LoggingProtocol

    private init(with logger: LoggingProtocol) {
        self.defaultLogger = logger
    }

    func log(_ message: String, level: LogLevel = .debug) {
        defaultLogger.log(message, level: level)
    }
}
