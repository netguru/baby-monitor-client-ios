import Foundation
import RxSwift

@testable import BabyMonitor

final class SocketCommunicationManagerMock: SocketCommunicationManager {
    
    let communicationResetPublisher = PublishSubject<Void>()
    var communicationResetObservable: Observable<Void> {
        return communicationResetPublisher
    }
    
    let communicationTerminationPublisher = PublishSubject<Void>()
    var communicationTerminationObservable: Observable<Void> {
        return communicationTerminationPublisher
    }
    
    let connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        return connectionStatusPublisher
    }
    
    func reset() {}
    func terminate() {}
}
