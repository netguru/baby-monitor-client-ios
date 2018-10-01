//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    var rootCoordinator: Coordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        rootCoordinator = RootCoordinator(navigationController)
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
		return true
	}

}
