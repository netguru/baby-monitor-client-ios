//
//  MediaPlayerStreamingService.swift
//  Baby Monitor
//

import Foundation

protocol VideoStreamingService: AnyObject {
    
    /// Video streaming data source
    var dataSource: VideoStreamingServiceDataSource? { get set }
    
    /// Starts video streaming
    func startStreaming()
    /// Stops video streaming
    func stopStreaming()
}

protocol VideoStreamingServiceDataSource: AnyObject {
    var videoView: UIView { get }
}

final class MediaPlayerStreamingService: VideoStreamingService {
    
    weak var dataSource: VideoStreamingServiceDataSource?
    
    private let cameraServer: CameraServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    
    init(netServiceServer: NetServiceServerProtocol, cameraServer: CameraServerProtocol) {
        self.netServiceServer = netServiceServer
        self.cameraServer = cameraServer
    }
    
    func startStreaming() {
        cameraServer.startup()
        let previewLayer = cameraServer.getPreviewLayer()
        guard let layer = previewLayer else {
            return
        }
        layer.removeFromSuperlayer()
        layer.frame = UIScreen.main.bounds
        layer.connection?.videoOrientation = .portrait
        dataSource?.videoView.layer.addSublayer(layer)
        netServiceServer.publish()
    }
    
    func stopStreaming() {
        cameraServer.shutdown()
        netServiceServer.stop()
    }
}
