import Foundation
import RxSwift
import WebRTC

enum WebSocketConnectionStatus {
    case connected
    case connecting
    case disconnected
}

protocol WebSocketConnectionStatusProvider {
    
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> { get }
}

extension RTCSignalingState {
    
    func toSocketConnectionState() -> WebSocketConnectionStatus {
        switch self {
        case .closed:
            return .disconnected
        case .stable:
            return .connected
        default:
            return .connecting
        }
    }
}
