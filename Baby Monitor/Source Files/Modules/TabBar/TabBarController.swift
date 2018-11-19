//
//  TabBarController.swift
//  Baby Monitor
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let viewControllersTitles = [
        Localizable.TabBar.dashboard,
        Localizable.TabBar.activityLog,
        // TODO: Hidden for MVP
        // Localizable.TabBar.lullabies,
        Localizable.TabBar.settings
    ]
    
    private let viewControllersImages = [
        #imageLiteral(resourceName: "dashboard"),
        #imageLiteral(resourceName: "activityLog"),
        // TODO: Hidden for MVP
        // #imageLiteral(resourceName: "musicNote"),
        #imageLiteral(resourceName: "settings")
    ]
    
    /// Setups titles for tab bar view controllers
    func setupTitles() {
        guard let viewControllers = viewControllers else {
            return
        }
        for (controller, title) in zip(viewControllers, viewControllersTitles) {
            controller.tabBarItem.title = title
        }
        
        for (controller, image) in zip(viewControllers, viewControllersImages) {
            controller.tabBarItem.image = image
        }
    }
}
