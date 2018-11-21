//
//  UserDefaultsURLConfiguration.swift
//  Baby Monitor
//

final class UserDefaultsURLConfiguration: URLConfiguration {
    
    private var cachedUrl: URL?
    
    private let userDefaults: URLUserDefaults
    
    static let keyUrl = "key_server_url"
    
    init(userDefaults: URLUserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var url: URL? {
        get {
            if cachedUrl == nil {
                cachedUrl = userDefaults.url(forKey: UserDefaultsURLConfiguration.keyUrl)
            }
            return cachedUrl
        }
        set {
            cachedUrl = newValue
            userDefaults.set(newValue, forKey: UserDefaultsURLConfiguration.keyUrl)
        }
    }
}
