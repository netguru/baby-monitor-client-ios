//
//  AppDelegate.swift
//  Baby Monitor
//

import UIKit
import Firebase
import UserNotifications
import WebRTC

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: RootCoordinatorProtocol?
    private(set) var appDependencies = AppDependencies()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator = RootCoordinator(window!, appDependencies: appDependencies)
        rootCoordinator?.start()
        rootCoordinator?.onReset = { [weak self] in
            // This line is extremely important. After resseting the app we may want to establish new
            // WebRTC connection. Thanks to deinitializing and initializing AppDependencies again we are
            // sure that old connection is properly cleared.
            // UPD: TODO: Needed to check whether other view models are not keeping reference to the old dependencies.
            let dependencies = AppDependencies()
            self?.rootCoordinator?.update(dependencies: dependencies)
            self?.appDependencies = dependencies
        }
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

    func applicationWillTerminate(_ application: UIApplication) {
        appDependencies.audioMicrophoneService?.stopCapturing()
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard application.applicationState != .active else {
            completionHandler(.noData)
            return
        }
        appDependencies.databaseRepository.save(activityLogEvent: ActivityLogEvent(mode: UserDefaults.soundDetectionMode.activityEventMode), completion: { _ in
            completionHandler(.noData)
        })
    }

}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.selfPushNotificationsToken = fcmToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        appDependencies.databaseRepository.save(activityLogEvent: ActivityLogEvent(mode: UserDefaults.soundDetectionMode.activityEventMode), completion: { _ in
            completionHandler([.alert, .sound, .badge])
        })
    }
}
