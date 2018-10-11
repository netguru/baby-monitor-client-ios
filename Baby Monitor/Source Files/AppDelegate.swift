//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: RootCoordinatorProtocol?
    var appDependencies = AppDependencies()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator = RootCoordinator(window!, appDependencies: appDependencies)
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
    
}
