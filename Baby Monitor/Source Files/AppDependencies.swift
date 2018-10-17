//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation

struct AppDependencies {
    
    /// Media player for getting and playing video baby stream
    private(set) lazy var mediaPlayer: MediaPlayerProtocol = VLCMediaPlayerService()
}
