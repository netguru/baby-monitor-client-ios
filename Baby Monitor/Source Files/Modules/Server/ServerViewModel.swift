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
    var onAudioRecordServiceError: (() -> Void)?
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
        serverService.audioRecordServiceErrorObservable.subscribe(onNext: { [weak self] _ in
            self?.onAudioRecordServiceError?()
        })
            .disposed(by: bag)
    }
}
