//
//  NotificationService.swift
//  Baby Monitor
//
 
import UserNotifications
import FirebaseInstanceID

protocol NotificationServiceProtocol: AnyObject {
    func sendPushNotificationsRequest(mode: SoundDetectionMode, completion: @escaping ((Result<Data>) -> Void))
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void)
    func resetTokens(completion: @escaping (Error?) -> Void)
}

final class NotificationService: NotificationServiceProtocol {
    enum TokenError: Error {
        case noReceiverTokenError

        var localizedDescription: String {
            return "No receiver notifications token."
        }
    }

    private let networkDispatcher: NetworkDispatcherProtocol
    private let serverKeyObtainable: ServerKeyObtainableProtocol
    private let analytics: AnalyticsManager
    
    init(networkDispatcher: NetworkDispatcherProtocol,
         serverKeyObtainable: ServerKeyObtainableProtocol,
         analytics: AnalyticsManager) {
        self.networkDispatcher = networkDispatcher
        self.serverKeyObtainable = serverKeyObtainable
        self.analytics = analytics
    }
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            completion(isGranted)
        }
    }
    
    func sendPushNotificationsRequest(mode: SoundDetectionMode, completion: @escaping ((Result<Data>) -> Void)) {
        guard let receiverId = UserDefaults.receiverPushNotificationsToken else {
            completion(Result.failure(TokenError.noReceiverTokenError))
            return
        }
        let firebasePushNotificationsRequest = FirebasePushNotificationsRequest(
            receiverId: receiverId,
            serverKey: serverKeyObtainable.serverKey,
            mode: mode)
        .asURLRequest()
        networkDispatcher.execute(urlRequest: firebasePushNotificationsRequest, completion: completion)
        analytics.logEvent(.notificationSent)
    }

    func resetTokens(completion: @escaping (Error?) -> Void) {
        InstanceID.instanceID().deleteID { error in
            completion(error)
        }
    }
}
