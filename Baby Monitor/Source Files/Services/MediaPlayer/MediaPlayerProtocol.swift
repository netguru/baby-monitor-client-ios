//
//  MediaPlayerProtocol.swift
//  Baby Monitor
//

import UIKit

protocol MediaPlayerDataSource: AnyObject {
    
    /// View that is needed to render video
    var videoView: UIView { get set }
}

/// Protocol that should be conformed by every new class of media player service
protocol MediaPlayerProtocol: AnyObject {
    
    var dataSource: MediaPlayerDataSource? { get set }
    
    /// Plays video
    func playVideo()
    
    /// Pauses currently played video
    func pauseVideo()
    
    /// Stops currently played video
    func stopVideo()
    
    /// Starts initial configuration. Must be called before other methods.
    func startupConfiguration()
}
