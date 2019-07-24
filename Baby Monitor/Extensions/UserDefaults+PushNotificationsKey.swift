//
//  UserDefaults+PushNotificationsKey.swift
//  Baby Monitor
//


import Foundation

extension UserDefaults {
    
    private static var selfPushNotificationsKey = "SELF_PUSH_NOTIFICATIONS_KEY"
    private static var receiverPushNotificationsKey = "RECEIVER_PUSH_NOTIFICATIONS_KEY"
    
    static var selfPushNotificationsToken: String {
        get {
            let token = UserDefaults.standard.string(forKey: selfPushNotificationsKey) ?? ""
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selfPushNotificationsKey)
        }
    }
    
    static var receiverPushNotificationsToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: receiverPushNotificationsKey)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: receiverPushNotificationsKey)
        }
    }
}
