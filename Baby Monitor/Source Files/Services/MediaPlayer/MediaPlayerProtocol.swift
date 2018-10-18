//
//  MediaPlayerProtocol.swift
//  Baby Monitor
//


import UIKit

protocol MediaPlayerDataSource: class {
    
    /// View that is needed to render video
    var videoView: UIView { get set }
}

/// Protocol that should be conformed by every new class of media player service
protocol MediaPlayerProtocol: class {
    
    var dataSource: MediaPlayerDataSource? { get set }
    
    /// Plays video
    func play()
    
    /// Pauses video
    func pause()
    
    /// Stops video
    func stop()
}
