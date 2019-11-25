import Foundation
import RxSwift

protocol SocketCommunicationManager: class {
    var communicationResetted: PublishSubject<Void> { get }
    var communicationTerminated: PublishSubject<Void> { get }
    func reset()
    func terminate()
}

class DefaultSocketCommunicationManager: SocketCommunicationManager {
    private(set) var communicationResetted =  PublishSubject<Void>()
    private(set) var communicationTerminated = PublishSubject<Void>()
    private unowned var webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var webSocket: ClearableLazyItem<WebSocketProtocol?>
    
    init(webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
         webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
         webSocket: ClearableLazyItem<WebSocketProtocol?>) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.webSocketWebRtcService = webSocketWebRtcService
        self.webSocket = webSocket
    }
    
    func reset() {
        terminate()
        webSocketEventMessageService.get().start()
        webSocketWebRtcService.get().start()
        communicationResetted.onNext(())
    }
    
    func terminate() {
        webSocketWebRtcService.clear()
        webSocketEventMessageService.clear()
        webSocket.clear()
        communicationTerminated.onNext(())
    }
}
