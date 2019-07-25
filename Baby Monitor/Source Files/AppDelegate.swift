//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit
import Firebase
import UserNotifications

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
        setupPushNotifications(application)
        appDependencies.storageServerService.uploadRecordingsToDatabaseIfAllowed()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if REGULAR_BUILD
        appDependencies.memoryCleaner.cleanMemoryIfNeeded()
        #endif
    }
    
    private func setupPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [ .badge, .sound, .alert
        ]) { granted, _ in
            guard granted else { return }
            UNUserNotificationCenter.current().delegate = self
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func setupAppearance() {
        UITabBar.appearance().tintColor = UIColor(named: "purple")
        UINavigationBar.appearance().barTintColor = UIColor(named: "darkPurple")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        appDependencies.databaseRepository.save(activityLogEvent: ActivityLogEvent(mode: .cryingEvent))
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.selfPushNotificationsToken = fcmToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
