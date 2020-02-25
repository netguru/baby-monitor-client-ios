//
//  FirebaseAnalyticsTracker.swift
//  Baby Monitor

import FirebaseAnalytics

/// The analytics service using Firebase.
struct FirebaseAnalyticsTracker: AnalyticsProtocol {

    func logScreen(name: String, className: String) {
        Analytics.setScreenName(name, screenClass: className)
    }

    func logEvent(_ eventName: String, parameters: [String: Any]?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    func logUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}
