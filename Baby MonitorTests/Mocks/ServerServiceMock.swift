//
//  ServerServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class ServerServiceMock: ServerServiceProtocol {

    var localStreamObservable: Observable<WebRTCMediaStream> = Observable.just(WebRTCMediaStreamMock())

    var audioMicrophoneServiceErrorObservable: Observable<Void> = Observable.just(())

    var remoteResetEventObservable: Observable<Void> = Observable.just(())

    var remoteParingCodeObservable: Observable<String> = Observable.just("")

    var loggingInfoObservable: Observable<String> = Observable.just("")

    var connectionStatusObservable: Observable<WebSocketConnectionStatus> = Observable.just(.connected)
    
    private(set) var stopCalled = false

    func startStreaming() {}

    func stop() {
        stopCalled = true
    }

    func pauseVideoStreaming() {}
    func resumeVideoStreaming() {}
}
