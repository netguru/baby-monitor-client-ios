import Foundation
import AudioKit
import RxSwift

protocol ApplicationResetter: class {
    var localResetCompleted: PublishSubject<Bool> { get }
    func reset(isRemote: Bool)
}

class DefaultApplicationResetter: ApplicationResetter {
    
    private unowned var messageServer: MessageServerProtocol
    private unowned var webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private unowned var babyModelControllerProtocol: BabyModelControllerProtocol
    private unowned var memoryCleaner: MemoryCleanerProtocol
    private unowned var urlConfiguration: URLConfiguration
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var localNotificationService: NotificationServiceProtocol
    
    private(set) var localResetCompleted = PublishSubject<Bool>()
    
    init(messageServer: MessageServerProtocol,
         webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
         babyModelControllerProtocol: BabyModelControllerProtocol,
         memoryCleaner: MemoryCleanerProtocol,
         urlConfiguration: URLConfiguration,
         webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
         localNotificationService: NotificationServiceProtocol) {
        self.messageServer = messageServer
        self.webSocketEventMessageService = webSocketEventMessageService
        self.babyModelControllerProtocol = babyModelControllerProtocol
        self.memoryCleaner = memoryCleaner
        self.urlConfiguration = urlConfiguration
        self.webSocketWebRtcService = webSocketWebRtcService
        self.localNotificationService = localNotificationService
    }
    
    func reset(isRemote: Bool) {
        localResetCompleted.onNext(false)
        
        if !isRemote {
            sendResetEvent()
        }
        clearNotificationTokens()
        clearLocalCache()
        babyModelControllerProtocol.removeAllData()
        memoryCleaner.cleanMemory()
        urlConfiguration.url = nil
        webSocketWebRtcService.get().close()
        stopAudioKit()
        
        localResetCompleted.onNext(true)
    }
}

private extension DefaultApplicationResetter {
    
    func sendResetEvent() {
        let resetEventString = EventMessage.initWithResetKey().toStringMessage()
        switch UserDefaults.appMode {
        case .baby:
            messageServer.send(message: resetEventString)
        case .parent:
            webSocketEventMessageService.get().sendMessage(resetEventString)
        case .none:
            break
        }
    }
    
    func clearLocalCache() {
        UserDefaults.appMode = .none
        UserDefaults.isSendingCryingsAllowed = false
        UserDefaults.selfPushNotificationsToken = ""
        UserDefaults.receiverPushNotificationsToken = nil
    }
    
    func clearNotificationTokens() {
        if UserDefaults.appMode == .parent {
            localNotificationService.resetTokens(completion: { _ in })
        }
    }
    
    func stopAudioKit() {
        try? AudioKit.stop()
    }
}

