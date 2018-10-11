//
//  UIViewController+ChildViewController.swift
//  Baby Monitor
//


import UIKit

extension UIViewController {
    
    /// Adds child view controller to view controller
    ///
    /// - Parameter child: child view controller
    func addChildViewController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Removes view controller from it's parent
    func removeFromParentViewController() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
