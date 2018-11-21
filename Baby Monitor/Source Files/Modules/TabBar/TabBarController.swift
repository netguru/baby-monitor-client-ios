//
//  TabBarController.swift
//  Baby Monitor
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let viewControllersImages = [
        #imageLiteral(resourceName: "apps"),
        #imageLiteral(resourceName: "pulse-sleep"),
        // TODO: Hidden for MVP
        // #imageLiteral(resourceName: "night"),
        #imageLiteral(resourceName: "preferences-circle")
    ]
    
    /// Setups buttons for tab bar view controllers
    func setupTabBarItems() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        for (controller, image) in zip(viewControllers, viewControllersImages) {
            let tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            controller.tabBarItem = tabBarItem
        }
    }
}
