//
//  MediaPlayerStreamingService.swift
//  Baby Monitor
//

import Foundation

protocol VideoStreamingServiceProtocol: AnyObject {
    
    /// Starts video streaming
    ///
    /// - Parameter videoView: view on which video will be displayed
    func startStreaming(videoView: UIView)
    
    /// Stops video streaming
    func stopStreaming()
}

final class MediaPlayerStreamingService: VideoStreamingServiceProtocol {
    
    private let cameraServer: CameraServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    
    init(netServiceServer: NetServiceServerProtocol, cameraServer: CameraServerProtocol) {
        self.netServiceServer = netServiceServer
        self.cameraServer = cameraServer
    }
    
    func startStreaming(videoView: UIView) {
        cameraServer.startup()
        guard let previewLayer = cameraServer.getPreviewLayer() else {
            return
        }
        previewLayer.removeFromSuperlayer()
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.connection?.videoOrientation = .portrait
        videoView.layer.addSublayer(previewLayer)
        netServiceServer.publish()
    }
    
    func stopStreaming() {
        cameraServer.shutdown()
        netServiceServer.stop()
    }
}
