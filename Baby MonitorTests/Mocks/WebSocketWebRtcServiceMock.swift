import Foundation
@testable import BabyMonitor
import RxTest
import RxSwift

class WebSocketWebRtcServiceMock: WebSocketWebRtcServiceProtocol {
    
    var mediaStream: Observable<WebRTCMediaStream?> {
        return mediaStreamEmitter.asObservable()
    }
    var connectionStateObservable: Observable<WebSocketConnectionStatus> {
        return stateEmitter.asObservable()
    }
    
    private(set) var startCalled = false
    private(set) var closeCalled = false
    private(set) var didAddAudioTrack = false
    private(set) var didStopAudioTrack = false
    private(set) var closeWebRtcConnectionCalled = false
    
    var mediaStreamEmitter = PublishSubject<WebRTCMediaStream?>()
    var stateEmitter = PublishSubject<WebSocketConnectionStatus>()
    
    let connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        return connectionStatusPublisher
    }
    
    func start() {
        startCalled = true
    }
    
    func close() {
        closeCalled = true
    }
    
    func closeWebRtcConnection() {
        closeWebRtcConnectionCalled = false
    }
    
    func startAudioTransmitting() {
        didAddAudioTrack = true
    }

    func stopAudioTransmitting() {
        didStopAudioTrack = true
    }
}
