//
//  AnalyticsViewModel.swift
//  Baby Monitor

/// The protocol which ensures analytics being used in the view model.
protocol AnalyticsViewModel {

    /// The analytics manager for tracking events.
    var analytics: AnalyticsManager { get }
}
