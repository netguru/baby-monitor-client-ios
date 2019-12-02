//
//  LoggingProtocol.swift
//  Baby Monitor
//

enum LogLevel {
   case info, debug, warning, error(Error? = nil)
}

protocol LoggingProtocol {
    func log(_ message: String, level: LogLevel, _ file: String, _ function: String, _ line: Int)
}
