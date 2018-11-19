//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import RTSPServer
import RxSwift

final class ServerViewModel {
    
    var onCryingEventOccurence: ((Bool) -> Void)?
    
    private let mediaPlayerStreamingService: VideoStreamingServiceProtocol
    private let cryingEventService: CryingEventsServiceProtocol
    private let babiesRepository: BabiesRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(mediaPlayerStreamingService: VideoStreamingServiceProtocol, cryingService: CryingEventsServiceProtocol, babiesRepository: BabiesRepositoryProtocol) {
        self.mediaPlayerStreamingService = mediaPlayerStreamingService
        self.cryingEventService = cryingService
        self.babiesRepository = babiesRepository
        
        setup()
        rxSetup()
    }
    
    deinit {
        mediaPlayerStreamingService.stopStreaming()
        cryingEventService.stop()
    }
    
    /// Starts streaming and detecting crying events
    func start(videoView: UIView) {
        mediaPlayerStreamingService.startStreaming(videoView: videoView)
        cryingEventService.start()
    }
    
    private func setup() {
        _ = babiesRepository.getCurrentBaby()
    }
    
    private func rxSetup() {
        cryingEventService.cryingEventObservable.subscribe(onNext: { [weak self] isCrying in
            self?.onCryingEventOccurence?(isCrying)
        }).disposed(by: disposeBag)
    }
}

protocol CameraServerProtocol {
    
    /// Starts camera server. Must be called before 'getPreviewLayer' function
    func startup()
    /// Shutdowns camera server
    func shutdown()
    /// Gets video layer that should be added to another view
    ///
    /// - Returns: video layer
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer!
}

extension CameraServer: CameraServerProtocol { }
