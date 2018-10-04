//
//  UIViewController+ChildViewController.swift
//  Baby Monitor
//


import UIKit

extension UIViewController {
    
    /// Adds child view controller to view controller
    ///
    /// - Parameter child: child view controller
    func addChild(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    /// Removes view controller from it's parent
    func removeFromParent() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
