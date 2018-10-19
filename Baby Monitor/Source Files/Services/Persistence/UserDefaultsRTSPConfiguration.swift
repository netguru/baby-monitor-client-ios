//
//  UserDefaultsRTSPConfiguration.swift
//  Baby Monitor
//

final class UserDefaultsRTSPConfiguration: RTSPConfiguration {
    
    private var cachedUrl: URL?
    
    private let userDefaults: URLUserDefaults
    
    static let keyUrl = "rtsp_key_url"
    
    init(userDefaults: URLUserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var url: URL? {
        get {
            if cachedUrl == nil {
                cachedUrl = userDefaults.url(forKey: UserDefaultsRTSPConfiguration.keyUrl)
            }
            return cachedUrl
        }
        set {
            cachedUrl = newValue
            userDefaults.set(newValue, forKey: UserDefaultsRTSPConfiguration.keyUrl)
        }
    }
}
