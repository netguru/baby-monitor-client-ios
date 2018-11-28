//
//  TypedPageViewController.swift
//  Baby Monitor
//

import UIKit

/// Base class for view controllers with programatically created `BackgroundView`
internal class TypedPageViewController<BackgroundView: UIView>: BasePageViewController {
    
    /// Custom View
    let customView: BackgroundView
    
    /// Initializes view controller with given BackgroundView
    ///
    /// - Parameter viewMaker: Maker for the UIView
    init(viewMaker: @escaping @autoclosure () -> BackgroundView) {
        self.customView = viewMaker()
        super.init()
    }
    
    /// - SeeAlso: UIViewController.loadView()
    override func loadView() {
        super.loadView()
        view.addSubview(customView)
        view.sendSubviewToBack(customView)
    }

}
