//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: RootCoordinatorProtocol?
    let appDependencies = AppDependencies()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator = RootCoordinator(window!, appDependencies: appDependencies)
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
        setupAppearance()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if REGULAR_BUILD
            appDependencies.memoryCleaner.cleanMemoryIfNeeded()
        #endif
    }
    
    private func setupAppearance() {
        UITabBar.appearance().tintColor = UIColor(named: "purple")
        UINavigationBar.appearance().barTintColor = UIColor(named: "darkPurple")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
    }
    
}
