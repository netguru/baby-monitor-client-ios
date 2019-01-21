//
//  UserDefaults+AppMode.swift
//  Baby Monitor
//

import Foundation

enum AppMode: String {
    case parent = "APP_MODE_PARENT_VALUE"
    case baby = "APP_MODE_BABY_VALUE"
    case none = "APP_MODE_NONE_VALUE"
}

extension UserDefaults {
    
    private static var appModeKey = "APP_MODE_KEY"
    
    static var appMode: AppMode {
        get {
            let rawValue = UserDefaults.standard.string(forKey: appModeKey) ?? AppMode.none.rawValue
            return AppMode(rawValue: rawValue) ?? .none
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: appModeKey)
        }
    }
}
