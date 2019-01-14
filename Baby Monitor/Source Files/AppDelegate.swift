//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit
import Firebase

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
        setupNotifications(application: application)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        appDependencies.storageServerService.uploadRecordingsToDatabaseIfNeeded()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if REGULAR_BUILD
            appDependencies.memoryCleaner.cleanMemoryIfNeeded()
        #endif
    }
    
    private func setupNotifications(application: UIApplication) {
        appDependencies.localNotificationService.getNotificationsAllowance { isGranted in
            guard isGranted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            
        }
    }
    
    private func setupAppearance() {
        UITabBar.appearance().tintColor = UIColor(named: "purple")
        UINavigationBar.appearance().barTintColor = UIColor(named: "darkPurple")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        appDependencies.cacheService.selfPushNotificationsToken = fcmToken
    }
}
