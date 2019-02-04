//
//  UserDefaults+SendingCryingAllowance.swift
//  Baby Monitor
//

import Foundation

extension UserDefaults {
    
    private static var sendingCryingsKey: String {
       return "SENDING_CRYINGS_KEY"
    }

    static var isSendingCryingsAllowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: sendingCryingsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sendingCryingsKey)
        }
    }
}
