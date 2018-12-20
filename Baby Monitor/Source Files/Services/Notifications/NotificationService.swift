//
//  NotificationService.swift
//  Baby Monitor
//
 
import UserNotifications

protocol NotificationServiceProtocol: AnyObject {
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void)
}

final class NotificationService: NotificationServiceProtocol {
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            completion(isGranted)
        }
    }
}
