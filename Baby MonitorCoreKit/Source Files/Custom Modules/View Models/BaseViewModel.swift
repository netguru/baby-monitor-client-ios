//
//  BaseViewModel.swift
//  Baby Monitor

/// The base view model to be used in the project.
class BaseViewModel: AnalyticsViewModel {

    let analytics: AnalyticsManager

    /// Initializes the view model.
    /// - Parameters:
    ///     - analytics: Analytics manager for tracking screens appearance.
    init(analytics: AnalyticsManager) {
        self.analytics = analytics
    }
}
