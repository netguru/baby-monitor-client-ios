//
//  Localizable.swift
//  Baby Monitor
//


import Foundation

struct Localizable {
    
    struct General {
        static let cancel = localized("general.cancel")
    }
    
    struct Onboarding {
        static let startClient = localized("onboarding.button.start-client")
        static let startServer = localized("onboarding.button.start-server")
        static let setupAddress = localized("onboarding.button.setup-address")
        static let startDiscovering = localized("onboarding.button.start-discovering")
        static let addressPlaceholder = localized("onboarding.text-field-placeholder.address")
    }
    
    struct TabBar {
        static let dashboard = localized("tab-bar.dashboard")
        static let activityLog = localized("tab-bar.activity-log")
        static let lullabies = localized("tab-bar.lullabies")
        static let settings = localized("tab-bar.settings")
    }
    
    struct Dashboard {
        static let liveCamera = localized("dashboard.button.live-camera")
        static let talk = localized("dashboard.button.talk")
        static let playLullaby = localized("dashboard.button.play-lullaby")
        static let editProfile = localized("dashboard.bar-button-item.edit-profile")
    }
    
    struct SwitchBaby {
        static let addAnotherBaby = localized("switch-baby.add-another.baby")
    }
    
    struct Lullabies {
        static let bmLibrary = localized("lullabies.bm-library")
        static let yourLullabies = localized("lullabies.your-lullabies")
    }
    
    struct Settings {
        static let switchToServer = localized("settings.cell.switch-to-server")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
