//
//  AnalyticsManager.swift
//  Baby Monitor

import UIKit

final class AnalyticsManager {

    private let analyticsTracker: AnalyticsProtocol

    init(analyticsTracker: AnalyticsProtocol = FirebaseAnalyticsTracker()) {
        self.analyticsTracker = analyticsTracker
    }

    func logScreen(_ type: AnalyticsScreenType, className: String) {
        analyticsTracker.logScreen(name: type.rawValue, className: className)
    }
}
