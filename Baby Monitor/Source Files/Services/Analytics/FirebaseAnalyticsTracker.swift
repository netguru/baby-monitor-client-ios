//
//  FirebaseAnalyticsTracker.swift
//  Baby Monitor

import FirebaseAnalytics

struct FirebaseAnalyticsTracker: AnalyticsProtocol {

    func logScreen(name: String, className: String) {
        Analytics.setScreenName(name, screenClass: className)
    }
}
