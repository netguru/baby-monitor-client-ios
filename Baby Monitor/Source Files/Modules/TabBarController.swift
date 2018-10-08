//
//  TabBarController.swift
//  Baby Monitor
//


import UIKit

final class TabBarController: UITabBarController {
    
    private let viewControllersTitles = [
        Localizable.TabBar.dashboard,
        Localizable.TabBar.activityLog,
        Localizable.TabBar.lullabies,
        Localizable.TabBar.settings
    ]
    
    /// Setups titles for tab bar view controllers
    func setupTitles() {
        guard let viewControllers = viewControllers else {
            return
        }
        for (controller, title) in zip(viewControllers, viewControllersTitles) {
            controller.tabBarItem.title = title
        }
    }
}

