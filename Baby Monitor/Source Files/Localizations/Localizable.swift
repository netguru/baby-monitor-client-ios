//
//  Localizable.swift
//  Baby Monitor
//

import Foundation

enum Localizable {
    
    enum General {
        static let cancel = localized("general.cancel")
        static let disconnected = localized("general.disconnected")
        static let delete = localized("general.delete")
        static let ok = localized("general.ok")
    }
    
    enum Onboarding {
        static let startClient = localized("onboarding.button.start-client")
        static let startServer = localized("onboarding.button.start-server")
        static let setupAddress = localized("onboarding.button.setup-address")
        static let startDiscovering = localized("onboarding.button.start-discovering")
        static let addressPlaceholder = localized("onboarding.text-field-placeholder.address")
        static let parent = localized("onboarding.button.parent")
        static let baby = localized("onboarding.button.baby")
        static let specifyDevice = localized("onboarding.label.specify-this-device")
        static let welcomeTo = localized("onboarding.label.welcome-to")
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
    
    enum Server {
        static let babyIsCrying = localized("server.baby-is-crying")
        static let babyStoppedCrying = localized("server.baby-stopped-crying")
        static let audioRecordError = localized("server.audio-record-error")
    }
    
    enum Lullabies {
        static let bmLibrary = localized("lullabies.bm-library")
        static let yourLullabies = localized("lullabies.your-lullabies")
        static let hushLittleBaby = localized("lullabies.library.hush-little-baby")
        static let lullabyGoodnight = localized("lullabies.library.lullaby-goodnight")
        static let prettyLittleHorses = localized("lullabies.library.pretty-little-horses")
        static let rockAByeBaby = localized("lullabies.library.rock-a-bye-baby")
        static let twinkleTwinkleLittleStar = localized("lullabies.library.twinkle-twinkle-little-star")
    }
    
    enum Settings {
        static let switchToServer = localized("settings.cell.switch-to-server")
        static let changeServer = localized("settings.cell.change-server")
        static let useML = localized("settings.cell.use-ml")
        static let useStaticCryingDetection = localized("settings.cell.use-static-crying-detection")
        static let main = localized("settings.header.main")
        static let cryingDetectionMethod = localized("settings.header.crying-detection-method")
    }
    
    enum Errors {
        static let errorOccured = localized("errors.title.error-occured")
        static let unableToFind = localized("errors.message.unable-to-find")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
