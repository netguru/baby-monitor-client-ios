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
    private unowned var webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var webSocket: ClearableLazyItem<WebSocketProtocol?>
    private var communicationResetPublisher = PublishSubject<Void>()
    private var communicationTerminationPublisher = PublishSubject<Void>()
    private var socketConnectionStatusPublisher = BehaviorSubject<WebSocketConnectionStatus>(value: .disconnected)
    private let bag = DisposeBag()
    
    init(webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
        webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
        webSocket: ClearableLazyItem<WebSocketProtocol?>) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.webSocketWebRtcService = webSocketWebRtcService
        self.webSocket = webSocket
        setupRx()
    }
    
    func reset() {
        terminate()
        webSocketEventMessageService.start()
        webSocketWebRtcService.get().start()
        communicationResetPublisher.onNext(())
        setupRx()
    }
    
    func terminate() {
        webSocketWebRtcService.clear()
        webSocket.clear()
        communicationTerminationPublisher.onNext(())
        setupRx()
    }
    
    private func setupRx() {
        webSocket.get()?.connectionStatusObservable
            .bind(to: socketConnectionStatusPublisher)
            .disposed(by: bag)
    }
}
