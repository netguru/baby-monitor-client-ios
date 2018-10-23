//
//  Localizable.swift
//  Baby Monitor
//

import Foundation

enum Localizable {
    
    enum General {
        static let cancel = localized("general.cancel")
        static let disconnected = localized("general.disconnected")
    }
    
    enum Onboarding {
        static let startClient = localized("onboarding.button.start-client")
        static let startServer = localized("onboarding.button.start-server")
        static let setupAddress = localized("onboarding.button.setup-address")
        static let startDiscovering = localized("onboarding.button.start-discovering")
        static let addressPlaceholder = localized("onboarding.text-field-placeholder.address")
    }
    
    enum TabBar {
        static let dashboard = localized("tab-bar.dashboard")
        static let activityLog = localized("tab-bar.activity-log")
        static let lullabies = localized("tab-bar.lullabies")
        static let settings = localized("tab-bar.settings")
    }
    
    enum Dashboard {
        static let liveCamera = localized("dashboard.button.live-camera")
        static let talk = localized("dashboard.button.talk")
        static let playLullaby = localized("dashboard.button.play-lullaby")
        static let editProfile = localized("dashboard.bar-button-item.edit-profile")
        static let addPhoto = localized("dashboard.button.add-photo")
        static let chooseImage = localized("dashboard.action.choose-image")
        static let camera = localized("dashboard.action-button.camera")
        static let photoLibrary = localized("dashboard.action-button.photoLibrary")
        static let addName = localized("dashboard.text-field-placeholder.add-name")
    }
    
    enum SwitchBaby {
        static let addAnotherBaby = localized("switch-baby.add-another.baby")
    }
    
    enum Lullabies {
        static let bmLibrary = localized("lullabies.bm-library")
        static let yourLullabies = localized("lullabies.your-lullabies")
    }
    
    enum Settings {
        static let switchToServer = localized("settings.cell.switch-to-server")
        static let changeServer = localized("settings.cell.change-server")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
