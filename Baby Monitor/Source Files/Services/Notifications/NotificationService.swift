//
//  NotificationService.swift
//  Baby Monitor
//
 
import UserNotifications
import FirebaseInstanceID

protocol NotificationServiceProtocol: AnyObject {
    func sendPushNotificationsRequest()
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void)
    func resetTokens(completion: @escaping (Error?) -> Void)
}

final class NotificationService: NotificationServiceProtocol {
    
    private let networkDispatcher: NetworkDispatcherProtocol
    private let serverKeyObtainable: ServerKeyObtainableProtocol
    
    init(networkDispatcher: NetworkDispatcherProtocol, serverKeyObtainable: ServerKeyObtainableProtocol) {
        self.networkDispatcher = networkDispatcher
        self.serverKeyObtainable = serverKeyObtainable
    }
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            completion(isGranted)
        }
    }
    
    func sendPushNotificationsRequest() {
        guard let receiverId = UserDefaults.receiverPushNotificationsToken else {
            return
        }
        let firebasePushNotificationsRequest = FirebasePushNotificationsRequest(
            receiverId: receiverId,
            serverKey: serverKeyObtainable.serverKey)
        .asURLRequest()
        networkDispatcher.execute(urlRequest: firebasePushNotificationsRequest, completion: nil)
    }

    func resetTokens(completion: @escaping (Error?) -> Void) {
        InstanceID.instanceID().deleteID { error in
            completion(error)
        }
    }
}
