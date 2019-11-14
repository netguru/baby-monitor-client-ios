import Foundation
import AudioKit
import RxSwift

protocol ApplicationResetter: class {
    var localResetCompleted: Variable<Bool> { get }
    func reset()
}

class DefaultApplicationResetter: ApplicationResetter {
    
    private unowned var messageServer: MessageServerProtocol
    private unowned var webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private unowned var babyModelControllerProtocol: BabyModelControllerProtocol
    private unowned var memoryCleaner: MemoryCleanerProtocol
    private unowned var urlConfiguration: URLConfiguration
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    
    private(set) var localResetCompleted = Variable<Bool>(false)
    
    init(messageServer: MessageServerProtocol,
         webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
         babyModelControllerProtocol: BabyModelControllerProtocol,
         memoryCleaner: MemoryCleanerProtocol,
         urlConfiguration: URLConfiguration,
         webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>) {
        self.messageServer = messageServer
        self.webSocketEventMessageService = webSocketEventMessageService
        self.babyModelControllerProtocol = babyModelControllerProtocol
        self.memoryCleaner = memoryCleaner
        self.urlConfiguration = urlConfiguration
        self.webSocketWebRtcService = webSocketWebRtcService
    }
    
    func reset() {
        localResetCompleted.value = false
        
        sendResetEvent()
        babyModelControllerProtocol.removeAllData()
        memoryCleaner.cleanMemory()
        urlConfiguration.url = nil
        webSocketWebRtcService.get().close()
        UserDefaults.appMode = .none
        UserDefaults.isSendingCryingsAllowed = false
        stopAudioKit()
        
        localResetCompleted.value = true
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
    
    func stopAudioKit() {
        try? AudioKit.stop()
    }
}

