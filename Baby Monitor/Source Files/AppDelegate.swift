//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: RootCoordinatorProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator = RootCoordinator(window!)
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
    
}
