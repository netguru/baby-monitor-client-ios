//
//  RTSPConfiguration.swift
//  Baby Monitor
//

protocol RTSPConfiguration: AnyObject {
    
    /// Holds rtsp server url
    var url: URL? { get set }
}
