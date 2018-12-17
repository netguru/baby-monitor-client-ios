//
//  LocalNotificationsService.swift
//  Baby Monitor
//
 
import UserNotifications

protocol LocalNotificationsServiceProtocol: AnyObject {
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void)
    func triggerLocalNotification(title: String, body: String, after: TimeInterval)
}

final class LocalNotificationsService: LocalNotificationsServiceProtocol {
    
    private let center = UNUserNotificationCenter.current()
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            completion(isGranted)
        }
    }
    
    func triggerLocalNotification(title: String, body: String, after: TimeInterval = 0.0) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: after, repeats: false)
        let identifier = "BabyMonitorLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
}
