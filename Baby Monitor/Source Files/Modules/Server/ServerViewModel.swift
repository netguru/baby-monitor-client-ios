//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import RTSPServer

final class ServerViewModel {
    
    private let mediaPlayerStreamingService: VideoStreamingService
    
    init(mediaPlayerStreamingService: VideoStreamingService) {
        self.mediaPlayerStreamingService = mediaPlayerStreamingService
    }
    
    /// Starts streaming
    func startStreaming(videoView: UIView) {
        mediaPlayerStreamingService.startStreaming(videoView: videoView)
    }
    
    deinit {
        mediaPlayerStreamingService.stopStreaming()
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
