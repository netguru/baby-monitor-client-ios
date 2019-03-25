//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class ServerViewModel {
    
    var stream: Observable<MediaStream> {
        return serverService.localStreamObservable
    }
    var onAudioMicrophoneServiceError: (() -> Void)?
    var settingsTap: Observable<Void>?
    let bag = DisposeBag()
    
    private let serverService: ServerServiceProtocol
    
    init(serverService: ServerServiceProtocol) {
        self.serverService = serverService
        rxSetup()
    }
    
    deinit {
        serverService.stop()
    }
    
    /// Starts streaming
    func startStreaming() {
        serverService.startStreaming()
    }
    
    private func rxSetup() {
        serverService.audioMicrophoneServiceErrorObservable.subscribe(onNext: { [weak self] _ in
            self?.onAudioMicrophoneServiceError?()
        })
            .disposed(by: bag)
    }
}
