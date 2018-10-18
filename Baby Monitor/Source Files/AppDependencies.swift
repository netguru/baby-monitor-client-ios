//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation
import RTSPServer

struct AppDependencies {

    /// Media player for getting and playing video baby stream
    private(set) lazy var mediaPlayer: MediaPlayerProtocol = VLCMediaPlayerService(netServiceClient: netServiceClient)
    /// Media player for streaming video
    private(set) lazy var mediaPlayerStreamingService: VideoStreamingService = MediaPlayerStreamingService(netServiceServer: netServiceServer, cameraServer: cameraServer)

    private lazy var netServiceClient: NetServiceClientProtocol = NetServiceClient()
    private lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer()
    private lazy var cameraServer: CameraServerProtocol = CameraServer().server()

    /// Baby service for getting and adding babies throughout the app
    private(set) var babyService: BabyService = BabyService(dataSource: BabyData())
}
