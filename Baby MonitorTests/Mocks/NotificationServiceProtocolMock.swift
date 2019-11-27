import Foundation
import RxSwift
import RxTest

@testable import BabyMonitor

class NotificationServiceProtocolMock: NotificationServiceProtocol {
    
    private(set) var sendPushNotificationsRequestCalled = false
    private(set) var getNotificationsAllowanceCalled = false
    private(set) var resetTokensCalled = false
    
    func sendPushNotificationsRequest(completion: @escaping ((Result<Data>) -> Void)) {
        sendPushNotificationsRequestCalled = true
    }
    
    func getNotificationsAllowance(completion: @escaping (Bool) -> Void) {
        getNotificationsAllowanceCalled = true
    }
    
    func resetTokens(completion: @escaping (Error?) -> Void) {
        resetTokensCalled = true
    }
}
