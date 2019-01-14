//
//  NotificationService.swift
//  Baby Monitor
//
 
import UserNotifications

protocol NotificationServiceProtocol: AnyObject {
    func sendPushNotificationsRequest()
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void)
}

final class NotificationService: NotificationServiceProtocol {
    
    private let networkDispatcher: NetworkDispatcherProtocol
    private let cacheService: CacheServiceProtocol
    private let serverKeyObtainable: ServerKeyObtainableProtocol
    
    init(networkDispatcher: NetworkDispatcherProtocol, cacheService: CacheServiceProtocol, serverKeyObtainable: ServerKeyObtainableProtocol) {
        self.networkDispatcher = networkDispatcher
        self.cacheService = cacheService
        self.serverKeyObtainable = serverKeyObtainable
    }
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            completion(isGranted)
        }
    }
    
    func sendPushNotificationsRequest() {
        guard let receiverId = cacheService.receiverPushNotificationsToken else {
            return
        }
        let firebasePushNotificationsRequest = FirebasePushNotificationsRequest(
            receiverId: receiverId,
            serverKey: serverKeyObtainable.serverKey)
        .asURLRequest()
        networkDispatcher.execute(urlRequest: firebasePushNotificationsRequest, completion: nil)
    }
}
