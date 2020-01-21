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
    /// - Parameter viewMaker: Maker for the UIView
    init(viewMaker: @escaping @autoclosure () -> View, analyticsManager: AnalyticsManager? = nil, analyticsScreenType: AnalyticsScreenType? = nil) {
        self.customView = viewMaker()
        guard let analyticsManager = analyticsManager,
            let analyticsScreenType = analyticsScreenType else {
                assertionFailure("Analytics is not implemented for a screen.")
                super.init(analyticsManager: AnalyticsManager(), analyticsScreenType: .unrecognized) // TODO: Do not set unrecognized as a default
                return
        }
        super.init(analyticsManager: analyticsManager, analyticsScreenType: analyticsScreenType)
    }
    
    /// - SeeAlso: UIViewController.loadView()
    override func loadView() {
        view = customView
        view.clipsToBounds = true
    }
}
