import Foundation
import RxSwift

protocol SocketCommunicationManager: class {
    var communicationResetObservable: Observable<Void> { get }
    var communicationTerminationObservable: Observable<Void> { get }
    func reset()
    func terminate()
}

class DefaultSocketCommunicationManager: SocketCommunicationManager {
    private(set) var communicationResetObservable: Observable<Void>
    private(set) var communicationTerminationObservable: Observable<Void>
    private var communicationResetPublisher = PublishSubject<Void>()
    private var communicationTerminationPublisher = PublishSubject<Void>()
    private unowned var webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var webSocket: ClearableLazyItem<WebSocketProtocol?>
    
    init(webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
        webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
        webSocket: ClearableLazyItem<WebSocketProtocol?>) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.webSocketWebRtcService = webSocketWebRtcService
        self.webSocket = webSocket
        communicationResetObservable = communicationResetPublisher.asObservable()
        communicationTerminationObservable = communicationTerminationPublisher.asObservable()
    }
    
    func reset() {
        terminate()
        webSocketEventMessageService.get().start()
        webSocketWebRtcService.get().start()
        communicationResetPublisher.onNext(())
    }
    
    func terminate() {
        webSocketWebRtcService.clear()
        webSocketEventMessageService.clear()
        webSocket.clear()
        communicationTerminationPublisher.onNext(())
    }
}
