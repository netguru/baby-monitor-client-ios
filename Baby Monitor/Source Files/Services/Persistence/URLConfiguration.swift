//
//  URLConfiguration.swift
//  Baby Monitor
//

import Foundation

protocol URLConfiguration: AnyObject {
    
    /// Holds server url
    var url: URL? { get set }
}
