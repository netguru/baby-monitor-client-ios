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
    init(viewMaker: @escaping @autoclosure () -> View, analyticsManager: AnalyticsManager, analyticsScreenType: AnalyticsScreenType) {
        self.customView = viewMaker()
        super.init(analyticsManager: analyticsManager, analyticsScreenType: analyticsScreenType)
    }
    
    /// - SeeAlso: UIViewController.loadView()
    override func loadView() {
        view = customView
        view.clipsToBounds = true
    }
}
