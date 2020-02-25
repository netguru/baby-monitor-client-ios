//
//  AnalyticsManager.swift
//  Baby Monitor

import UIKit

/// A class managing the analytics in the app.
final class AnalyticsManager {

    private let analyticsTracker: AnalyticsProtocol

    /// Initializes the manager.
    /// - Parameter analyticsTracker: The tracker which is used for the analytics in the app.
    init(analyticsTracker: AnalyticsProtocol = FirebaseAnalyticsTracker()) {
        self.analyticsTracker = analyticsTracker
    }

    /// Logging a view controller's appearance.
    ///
    /// - Parameters:
    ///     - type: The type of the screen to be logged.
    ///     - className: The name of the class of the screen.
    func logScreen(_ type: AnalyticsScreenType, className: String) {
        analyticsTracker.logScreen(name: type.rawValue, className: className)
    }

    /// Logging custom events.
    /// - Parameter event: The event to be logged.
    func logEvent(_ event: AnalyticsEventType) {
        analyticsTracker.logEvent(event.eventName, parameters: event.parameters)
    }

    /// Set user property.
    /// - Parameter property: The property to be logged.
    func logUserProperty(_ property: AnalyticsPropertyType) {
        analyticsTracker.logUserProperty(property.value, forName: property.name)
    }
}
