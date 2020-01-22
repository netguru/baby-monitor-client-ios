//
//  TypedViewController.swift
//  Baby Monitor
//

import UIKit

/// Base class for view controllers with programatically created `View`
internal class TypedViewController<View: UIView>: BaseViewController {
    
    /// Custom View
    let customView: View
    
    /// Initializes view controller with given View
    ///
    /// - Parameters:
    ///     - viewMaker: Maker for the UIView.
    ///     - analytics: Analytics manager for tracking screens appearance.
    ///     - analyticsScreenType: The type of the screen in terms of analytics tracking.
    init(viewMaker: @escaping @autoclosure () -> View,
         analytics: AnalyticsManager? = nil,
         analyticsScreenType: AnalyticsScreenType? = nil) {
        self.customView = viewMaker()
        super.init(analytics: analytics, analyticsScreenType: analyticsScreenType)
    }
    
    /// - SeeAlso: UIViewController.loadView()
    override func loadView() {
        view = customView
        view.clipsToBounds = true
    }
}
