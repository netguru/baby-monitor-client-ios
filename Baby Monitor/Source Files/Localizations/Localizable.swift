//
//  Localizable.swift
//  Baby Monitor
//

import Foundation

enum Localizable {
    
    enum General {
        static let babyMonitor = localized("general.baby-monitor")
        static let cancel = localized("general.cancel")
        static let `continue` = localized("general.continue")
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
        static let letsStart = localized("general.lets-start")
        static let retry = localized("general.retry")
        static let imSureExitApp = localized("general.i-am-sure-exit")
        static let important = localized("general.important")
        static let version = localized("general.version")
        static let decline = localized("general.decline")
        static let accept = localized("general.accept")
    }
    
    enum Intro {
        enum Title {
            static let monitoring = localized("intro.title.monitoring")
            static let detection = localized("intro.title.detection")
            static let safety = localized("intro.title.safety")
            static let recordings = localized("intro.title.recordings")
        }
        enum Description {
            static let monitoring = localized("intro.description.monitoring")
            static let detection = localized("intro.description.detection")
            static let safety = localized("intro.description.safety")
            static let recordings = localized("intro.description.recordings")
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
        static let defineDevice = localized("onboarding.label.define-this-device")
        static let defineDescription = localized("onboarding.label.define-descripion")
        static let welcomeTo = localized("onboarding.label.welcome-to")
        
        enum BabySetup {
            static let permissionsDenidedText = localized("onboarding.baby-setup.permissions-denided.text")
            static let cameraAndMicrophonePermissionsDenied = localized("onboarding.baby-setup.camera-and-microphone-permissions-denied")
            static let cameraPermissionsDenied = localized("onboarding.baby-setup.camera-permission-denied")
            static let microphonePermissionsDenied = localized("onboarding.baby-setup.microphone-permission-denied")
            static let permissionsDenidedQuestion = localized("onboarding.baby-setup.permissions-denided-question.text")
            static let accessCameraMainDescription = localized("onboarding.baby-setup.access.camera.main-description")
            static let accessCameraSecondDescription = localized("onboarding.baby-setup.access.camera.second-description")
            static let accessMicrophoneMainDescription = localized("onboarding.baby-setup.access.microphone.main-description")
            static let accessMicrophoneSecondDescription = localized("onboarding.baby-setup.access.microphone.second-description")
            
        }

        enum SpecifyDevice {

            enum Info {
                static let title = localized("onboarding.specify-device.info.title")
                static let descriptionFirstPart = localized("onboarding.specify-device.info.description.first-part")
                static let descriptionOneText = localized("onboarding.specify-device.info.description.one-text")
                static let descriptionMiddlePart = localized("onboarding.specify-device.info.description.middle-part-text")
                static let descriptionTheOtherText = localized("onboarding.specify-device.info.description.the-other-text")
                static let descriptionLastPart = localized("onboarding.specify-device.info.description.last-part")
                static let stepDescription = localized("onboarding.specify-device.info.step-description")
                static let specifyButton = localized("onboarding.specify-device.info.specify-button")
                static let specifyParentButton = localized("onboarding.specify-device.info.specify-button-parent")
                static let specifyBabyButton = localized("onboarding.specify-device.info.specify-button-baby")
            }

            enum Specification {
                // TODO: Add in BM-321
            }
        }

        enum Connecting {
            static let connectToWiFi = localized("onboarding.connecting.connect-to-wi-fi")
            static let connectToWiFiButtonTitle = localized("onboarding.connecting.connect-to-wi-fi.title")
            static let setupInformation = localized("onboarding.connecting.setup-information")
            static let placeDevice = localized("onboarding.connecting.place-device")
            static let startMonitoring = localized("onboarding.connecting.start-monitoring")
            static let availableDevices = localized("onboarding.pairing.available-devices.title")
            static let refreshButtonTitle = localized("onboarding.pairing.refresh.button")
            static let compareCodeDescription = localized("onboarding.pairing.compare-code")
        }
        
        enum Pairing {
            static let hello = localized("onboarding.pairing.share-link.title")
            static let timeToInstallBabyMonitor = localized("onboarding.pairing.share-link.description")
            static let searchingForSecondDevice = localized("onboarding.pairing.connecting.description")
            static let done = localized("onboarding.pairing.done.description")
            static let error = localized("onboarding.pairing.error-description")
            static let errorSecondDescription = localized("onboarding.pairing.error-second-description")
            static let connectionErrorSecondDescription = localized("onboarding.pairing.connection-error-second-description")
            static let errorSecondDescriptionBottomPart = localized("onboarding.pairing.hello.second-description-bottom-part")
            static let tryAgain = localized("onboarding.pairing.try-again")
            static let startUsingBabyMonitor = localized("onboarding.pairing.start-using-baby-monitor")
            static let allDone = localized("onboarding.pairing.all-done")
            static let getStarted = localized("onboarding.pairing.get-started")
            static let connection = localized("onboarding.pairing.connection")
            static let unknownDevice = localized("onboarding.pairing.unknown-device")

            static func connectionAlertInfo(code: String) -> String {
                return String(format: localized("onboarding.pairing.connection-alert-info"), code)
            }
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
        static let noiseDetected = localized("activity-log.noise-detected")
    }
    
    enum SwitchBaby {
        static let addAnotherBaby = localized("switch-baby.add-another.baby")
    }
    
    enum Server {
        static let babyIsCrying = localized("server.baby-is-crying")
        static let noiseDetected = localized("server.noise-detected")
        static let babyStoppedCrying = localized("server.baby-stopped-crying")
        static let audioRecordError = localized("server.audio-record-error")
        static let streamError = localized("server.stream-error")
        static let noStream = localized("server.no-stream")
        static let noMicrophoneAccessMessage = localized("server.no-microphone-access-message")
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
        static let noiseDetection = localized("settings.voiceMode.noiseDetection")
        static let cryDetection = localized("settings.voiceMode.cryDetection")
        static let noiseLevel = localized("settings.voiceMode.noiseLevel")
        static let voiceModeFailedTitle = localized("settings.voiceMode.failed-title")
        static let voiceModeFailedDescription = localized("settings.voiceMode.failed-description")
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

    enum Video {
        static let videoDisabledDescription = localized("video.disabled.description")
    }
}

private func localized(_ value: String) -> String {
    return NSLocalizedString(value, comment: "")
}
