//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class ServerViewModel {
    
    var stream: Observable<RTCMediaStream> {
        return serverService.localStreamObservable
    }
    var onAudioRecordServiceError: (() -> Void)?
    
    private let serverService: ServerServiceProtocol
    private let bag = DisposeBag()
    
    init(serverService: ServerServiceProtocol) {
        self.serverService = serverService
        rxSetup()
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
