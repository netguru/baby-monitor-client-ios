//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class ServerViewModel: BaseViewModel {
    
    var stream: Observable<MediaStream> {
        return serverService.localStreamObservable
    }
    var loggingInfoObservable: Observable<String> {
        return serverService.loggingInfoObservable
    }
    var onAudioMicrophoneServiceError: (() -> Void)?
    var settingsTap: Observable<Void>?
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> { serverService.connectionStatusObservable }
    let bag = DisposeBag()
    
    private let serverService: ServerServiceProtocol
    
    init(serverService: ServerServiceProtocol, analytics: AnalyticsManager) {
        self.serverService = serverService
        super.init(analytics: analytics)
        rxSetup()
    }
    
    /// Starts streaming
    func startStreaming() {
        serverService.startStreaming()
    }

    func pauseVideoStreaming() {
        serverService.pauseVideoStreaming()
    }

    func resumeVideoStreaming() {
        serverService.resumeVideoStreaming()
    }
    
    private func rxSetup() {
        serverService.audioMicrophoneServiceErrorObservable.subscribe(onNext: { [weak self] _ in
            self?.onAudioMicrophoneServiceError?()
        })
        .disposed(by: bag)
    }
}
