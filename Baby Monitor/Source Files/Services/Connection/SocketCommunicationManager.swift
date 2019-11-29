import Foundation
import RxSwift

protocol SocketCommunicationManager: class, WebSocketConnectionStatusProvider {
    var communicationResetObservable: Observable<Void> { get }
    var communicationTerminationObservable: Observable<Void> { get }
    func reset()
    func terminate()
}

class DefaultSocketCommunicationManager: SocketCommunicationManager {
    var communicationResetObservable: Observable<Void> {
        return communicationResetPublisher.asObservable()
    }
    var communicationTerminationObservable: Observable<Void> {
        return communicationTerminationPublisher.asObservable()
    }
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        return socketConnectionStatusPublisher.asObservable()
    }
    private unowned var webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var webSocket: ClearableLazyItem<WebSocketProtocol?>
    private var communicationResetPublisher = PublishSubject<Void>()
    private var communicationTerminationPublisher = PublishSubject<Void>()
    private var socketConnectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    private let bag = DisposeBag()
    
    init(webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
        webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
        webSocket: ClearableLazyItem<WebSocketProtocol?>) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.webSocketWebRtcService = webSocketWebRtcService
        self.webSocket = webSocket
        setupRx()
    }
    
    func reset() {
        terminate()
        webSocketEventMessageService.get().start()
        webSocketWebRtcService.get().start()
        communicationResetPublisher.onNext(())
        setupRx()
    }
    
    func terminate() {
        webSocketWebRtcService.clear()
        webSocketEventMessageService.clear()
        webSocket.clear()
        communicationTerminationPublisher.onNext(())
    }
    
    private func setupRx() {
        webSocket.get()?.connectionStatusObservable
            .bind(to: socketConnectionStatusPublisher)
            .disposed(by: bag)
    }
}
