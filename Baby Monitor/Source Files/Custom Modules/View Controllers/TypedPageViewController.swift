//
//  TypedPageViewController.swift
//  Baby Monitor
//

import UIKit

/// Base class for page view controllers with programatically created `BackgroundView`
internal class TypedPageViewController<BackgroundView: UIView>: BasePageViewController {
    
    /// Custom View
    let customView: BackgroundView
    
    /// Initializes view controller with given BackgroundView
    ///
    /// - Parameters:
    ///     - viewMaker: Maker for the UIView.
    ///     - analytics: Analytics manager for tracking screens appearance.
    ///     - analyticsScreenType: The type of the screen in terms of analytics tracking.
    init(viewMaker: @escaping @autoclosure () -> BackgroundView,
         analytics: AnalyticsManager,
         analyticsScreenType: AnalyticsScreenType) {
        self.customView = viewMaker()
        super.init(analytics: analytics, analyticsScreenType: analyticsScreenType)
    }
    
    /// - SeeAlso: UIViewController.loadView()
    override func loadView() {
        super.loadView()
        view.addSubview(customView)
        view.sendSubviewToBack(customView)
    }
}
