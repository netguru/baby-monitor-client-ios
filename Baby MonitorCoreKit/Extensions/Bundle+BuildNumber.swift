//
//  Bundle+BuildNumber.swift
//  Baby Monitor
//

import Foundation

extension Bundle {

    var buildNumber: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    var bundleVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
