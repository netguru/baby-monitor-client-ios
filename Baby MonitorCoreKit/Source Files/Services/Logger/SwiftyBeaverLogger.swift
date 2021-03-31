//
//  SwiftyBeaverLogger.swift
//  Baby Monitor
//

import SwiftyBeaver

final class SwiftyBeaverLogger: LoggingProtocol {

    static let shared = SwiftyBeaverLogger()

    private let log: SwiftyBeaver.Type

    private init() {
        log = SwiftyBeaver.self
        let console = ConsoleDestination()
        console.levelString.debug = "💚 DEBUG"
        console.levelString.info = "💙 INFO"
        console.levelString.warning = "💛 WARNING"
        console.levelString.error = "❤️ ERROR"
        console.format = "$DHH:mm:ss$d $N.$F:$l $L: $M"
        log.addDestination(console)
    }

    func log(_ message: String, level: LogLevel, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        switch level {
        case .info:
            log.info(message, file, function, line: line)
        case .debug:
            log.debug(message, file, function, line: line)
        case .warning:
            log.warning(message, file, function, line: line)
        case .error(let error):
            if let error = error {
                log.error(message + error.localizedDescription, file, function, line: line)
            } else {
                log.error(message, file, function, line: line)
            }
        }
    }
}
