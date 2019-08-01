//
//  Bundle+BuildNumber.swift
//  Baby Monitor
//

import Foundation

extension Bundle {
    
    /// Build number.
    var buildNumber: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
}
