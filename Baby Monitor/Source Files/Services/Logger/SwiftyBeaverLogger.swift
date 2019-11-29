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
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
    }

    func log(_ message: String, level: LogLevel) {
        switch level {
        case .info:
            log.info(message)
        case .debug:
            log.debug(message)
        case .warning:
            log.warning(message)
        case .error(let error):
            if let error = error {
                log.error(message + error.localizedDescription)
            } else {
                log.error(message)
            }
        }
    }
}
