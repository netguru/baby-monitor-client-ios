//
//  LoggingProtocol.swift
//  Baby Monitor
//

enum LogLevel {
   case info, debug, error
}

protocol LoggingProtocol {
    func log(_ message: String, level: LogLevel)
}
