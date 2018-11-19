//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation
import RTSPServer
import RealmSwift
import AudioKit

struct AppDependencies {
    
    /// Service for cleaning too many crying events
    private(set) lazy var memoryCleaner: MemoryCleanerProtocol = MemoryCleaner(cryingEventsRepository: babiesRepository)
    /// Media player for getting and playing video baby stream
    private(set) lazy var mediaPlayer: MediaPlayerProtocol = VLCMediaPlayerService(netServiceClient: netServiceClient, rtspConfiguration: rtspConfiguration)
    /// Media player for streaming video
    private(set) lazy var mediaPlayerStreamingService: VideoStreamingServiceProtocol = MediaPlayerStreamingService(netServiceServer: netServiceServer, cameraServer: cameraServer)
    /// Service for recording audio
    private(set) lazy var audioRecordService: AudioRecordServiceProtocol? = try? AudioRecordService(recorderFactory: AudioKitRecorderFactory.makeRecorderFactory)
    /// Service for detecting baby's cry
    private(set) lazy var cryingDetectionService: CryingDetectionServiceProtocol = CryingDetectionService(microphoneTracker: AKMicrophoneTracker())
    /// Service that takes care of appropriate controling: crying detection, audio recording and saving these events to realm database
    private(set) lazy var cryingEventService: CryingEventsServiceProtocol = CryingEventService(cryingDetectionService: cryingDetectionService, audioRecordService: audioRecordService!, babiesRepository: babiesRepository)

    private(set) lazy var netServiceClient: NetServiceClientProtocol = NetServiceClient()
    private lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer()
    private lazy var cameraServer: CameraServerProtocol = CameraServer().server()

    private(set) lazy var connectionChecker: ConnectionChecker = NetServiceConnectionChecker(netServiceClient: netServiceClient, rtspConfiguration: rtspConfiguration)
    
    private(set) var rtspConfiguration: RTSPConfiguration = UserDefaultsRTSPConfiguration()
    /// Baby service for getting and adding babies throughout the app
    private(set) var babiesRepository: BabiesRepositoryProtocol & CryingEventsRepositoryProtocol = RealmBabiesRepository(realm: try! Realm())
    private(set) var lullabiesRepository: LullabiesRepositoryProtocol = RealmLullabiesRepository(realm: try! Realm())
}
