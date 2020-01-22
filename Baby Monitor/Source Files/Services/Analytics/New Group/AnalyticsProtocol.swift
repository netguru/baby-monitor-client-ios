//
//  AnalyticsProtocol.swift
//  Baby Monitor

/// A protocol  for logging to the analytics service.
protocol AnalyticsProtocol {

    /// Logging screen appearance.
    ///
    /// - Parameters:
    ///     - name: The custom name of the screen.
    ///     - className: The name of the class of the screen.
    func logScreen(name: String, className: String)

    /// Logging custom events.
    ///
    /// - Parameters:
    ///     - eventName: The custom name of the event.
    ///     - parameters: The parameters to be passed with the event.
    func logEvent(_ eventName: String, parameters: [String: Any]?)
}
