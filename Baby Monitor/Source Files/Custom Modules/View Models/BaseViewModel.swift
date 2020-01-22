//
//  BaseViewModel.swift
//  Baby Monitor

class BaseViewModel: AnalyticsViewModel {

    let analytics: AnalyticsManager

    init(analytics: AnalyticsManager) {
        self.analytics = analytics
    }
}
