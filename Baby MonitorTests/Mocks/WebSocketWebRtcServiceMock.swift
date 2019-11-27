import Foundation
@testable import BabyMonitor
import RxTest
import RxSwift


class WebSocketWebRtcServiceMock: WebSocketWebRtcServiceProtocol {
    
    var mediaStream: Observable<MediaStream?> {
        return mediaStreamEmitter.asObservable()
    }
    var state: Observable<WebRtcClientManagerState> {
        return stateEmitter.asObservable()
    }
    
    private(set) var startCalled = false
    private(set) var closeCalled = false
    private(set) var closeWebRtcConnectionCalled = false
    
    var mediaStreamEmitter = PublishSubject<MediaStream?>()
    var stateEmitter = PublishSubject<WebRtcClientManagerState>()
    
    func start() {
        startCalled = true
    }
    
    func close() {
        closeCalled = true
    }
    
    func closeWebRtcConnection() {
        closeWebRtcConnectionCalled = false
    }
}
