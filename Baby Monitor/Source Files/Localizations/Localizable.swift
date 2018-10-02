//
//  Localizable.swift
//  Baby Monitor
//


import Foundation

struct Localizable {
    
    struct TabBar {
        static let dashboard = localized("tab.bar.dashboard")
        static let activityLog = localized("tab.bar.activity.log")
        static let lullabies = localized("tab.bar.lullabies")
        static let settings = localized("tab.bar.settings")
    }
    
    struct Dashboard {
        static let liveCamera = localized("dashboard.button.live.camera")
        static let talk = localized("dashboard.button.talk")
        static let playLullaby = localized("dashboard.button.play.lullaby")
        static let editProfile = localized("dashboard.bar.button.item.edit.profile")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
