//
//  URLUserDefaults.swift
//  Baby Monitor
//

import Foundation

protocol URLUserDefaults {
    func url(forKey: String) -> URL?
    func set(_ url: URL?, forKey: String)
}

extension UserDefaults: URLUserDefaults {}
