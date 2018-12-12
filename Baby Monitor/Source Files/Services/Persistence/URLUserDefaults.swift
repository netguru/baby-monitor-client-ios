//
//  URLUserDefaults.swift
//  Baby Monitor
//

protocol URLUserDefaults {
    func url(forKey: String) -> URL?
    func set(_ url: URL?, forKey: String)
}

extension UserDefaults: URLUserDefaults {}
