//
//  Localizable.swift
//  Baby Monitor
//

import Foundation

enum Localizable {
    
    enum General {
        static let babyMonitor = localized("general.baby-monitor")
        static let cancel = localized("general.cancel")
        static let disconnected = localized("general.disconnected")
        static let delete = localized("general.delete")
        static let ok = localized("general.ok")
        static let next = localized("general.next")
        static let warning = localized("general.warning")
        static let attention = localized("general.attention")
        static let today = localized("general.today")
        static let yesterday = localized("general.yesterday")
        static let craftedWithLove = localized("general.craftedWithLove")
        static let byNetguru = localized("general.byNetguru")
        static let yourBaby = localized("general.your-baby")
    }
    
    enum Intro {
        enum Title {
            static let monitoring = localized("intro.title.monitoring")
            static let detection = localized("intro.title.detection")
            static let safety = localized("intro.title.safety")
        }
        enum Description {
            static let monitoring = localized("intro.description.monitoring")
            static let detection = localized("intro.description.detection")
            static let safety = localized("intro.description.safety")
        }
        enum Buttons {
            static let skip = localized("intro.button.skip")
            static let next = localized("intro.button.next")
        }
        static let sleepingSoundly = localized("intro.description.sleepingSoundly")
        static let setupBabyMonitor = localized("intro.button.setup-baby-monitor")
    }
    
    enum Onboarding {
        static let `continue` = localized("onboarding.continue")
        static let connecting = localized("onboarding.connecting")
        static let startClient = localized("onboarding.button.start-client")
        static let startServer = localized("onboarding.button.start-server")
        static let setupAddress = localized("onboarding.button.setup-address")
        static let startDiscovering = localized("onboarding.button.start-discovering")
        static let addressPlaceholder = localized("onboarding.text-field-placeholder.address")
        static let parent = localized("onboarding.button.parent")
        static let baby = localized("onboarding.button.baby")
        static let specifyDevice = localized("onboarding.label.specify-this-device")
        static let welcomeTo = localized("onboarding.label.welcome-to")
        
        enum Connecting {
            static let connectToWiFi = localized("onboarding.connecting.connect-to-wi-fi")
            static let setupInformation = localized("onboarding.connecting.setup-information")
            static let placeDevice = localized("onboarding.connecting.place-device")
            static let startMonitoring = localized("onboarding.connecting.start-monitoring")
        }
        
        enum Pairing {
            static let hello = localized("onboarding.pairing.share-link.title")
            static let timeToInstallBabyMonitor = localized("onboarding.pairing.share-link.description")
            static let searchingForSecondDevice = localized("onboarding.pairing.connecting.description")
            static let done = localized("onboarding.pairing.done.description")
            static let error = localized("onboarding.pairing.error-description")
            static let tryAgain = localized("onboarding.pairing.try-again")
            static let startUsingBabyMonitor = localized("onboarding.pairing.start-using-baby-monitor")
            static let allDone = localized("onboarding.pairing.all-done")
            static let getStarted = localized("onboarding.pairing.get-started")
        }
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
        static let yourBabyName = localized("dashboard.text-field-placeholder.your-baby-name")
        static let connectionStatusConnected = localized("dashboard.connection-status-connected")
        static let connectionStatusDisconnected = localized("dashboard.connection-status-disconnected")
    }
    
    enum ActivityLog {
        static let title = localized("activity-log.title")
        static let emptyStateMessage = localized("activity-log.empty-state.message")
        static let noMoreNotificationsMessage = localized("activity-log.no-more-notifications.message")
        static let wasCrying = localized("activity-log.was-crying")
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
        static let babyNamePlaceholder = localized("settings.babyNameTextField.placeholder")
        static let rateButtonTitle = localized("settings.rateButton.title")
        static let resetButtonTitle = localized("settings.resetButton.title")
        static let switchToServer = localized("settings.cell.switch-to-server")
        static let changeServer = localized("settings.cell.change-server")
        static let useML = localized("settings.cell.use-ml")
        static let useStaticCryingDetection = localized("settings.cell.use-static-crying-detection")
        static let main = localized("settings.header.main")
        static let cryingDetectionMethod = localized("settings.header.crying-detection-method")
        static let sendRecordingsToServer = localized("settings.cell.send-recordings-to-server")
        static let clearData = localized("settings.cell.clear-data")
        static let clearDataAlertMessage = localized("settings.cell.clear-data-alert-message")
        static let allowSendingBabyVoice = localized("settings.allow-sending.message")
        static let sendCryingsDescriptionFirstPart = localized("settings.send-cryings.description.first-part")
        static let withYourHelp = localized("settings.send-cryings.description.with-your-help")
        static let sendCryingsDescriptionSecondPart = localized("settings.send-cryings.description.second-part")
    }
    
    enum Errors {
        static let errorOccured = localized("errors.title.error-occured")
        static let unableToFind = localized("errors.message.unable-to-find")
        static let notificationsNotAllowed = localized("errors.notifications-not-allowed")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
