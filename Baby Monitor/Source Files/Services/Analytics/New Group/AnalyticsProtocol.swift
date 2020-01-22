//
//  AnalyticsProtocol.swift
//  Baby Monitor

protocol AnalyticsProtocol {
    func logScreen(name: String, className: String)
    func logEvent(_ eventName: String, parameters: [String: Any]?)
}
