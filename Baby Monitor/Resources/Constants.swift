//
//  Constants.swift
//  Baby Monitor
//

import UIKit

enum Constants {
    static let androidWebsocketPort = 10001
    static let iosWebsocketPort = 554
    static let netServiceType = "_http._tcp."
    static let protocolPrefix = "ws"
    static let domain = "local."
    static let netServiceName = "Baby Monitor Service"
    static let cryingDetectionThreshold = 0.7

    /// A limit per which one notification can be sent.
    static let notificationRequestTimeLimit: TimeInterval = 3 * 60

    /// A time after which the video stream should be hidden.
    static let videoStreamVisibilityTimeLimit: TimeInterval = 60

    /// A limit for searching for a baby device to be paired to.
    static let pairingDeviceSearchTimeLimit: TimeInterval = 2 * 60

    /// A limit for sending maximum one sound to an ML model for recognizing in this time.
    static let recognizingSoundTimeLimit: TimeInterval = 10

    /// An initial limit for sound loudness that should be cut off.
    static let loudnessFactorLimit = 35

    /// A limit for which should get a confirmation id back.
    static let webSocketConfimationIDTimeLimit: TimeInterval = 5

    /// The default mode to be used when not set.
    static let defaultSoundDetectionMode: SoundDetectionMode = .cryRecognition
    
    /// Represents a size class for constraint constants
    enum ResponsiveSizeClass {
        
        /// A size class for screens narrower than 320pt.
        /// In other words, for iPhone SE.
        case small
        
        /// A size class for screens wider than 320pt but narrower than 414pt.
        /// In other words, for iPhone 8 and XS.
        case medium
        
        /// A size class for screens wider than 414pt.
        /// In other words, for iPhone 8 Plus, XS Max and XR.
        case large
        
        static let value: ResponsiveSizeClass = {
            switch UIScreen.main.bounds.width {
            case ...320: return .small
            case 414...: return .large
            default: return .medium
            }
        }()
    }
    
    /// A responsive constant of given sizes to choose from.
    ///
    /// - Parameters:
    ///     - sizes: Sizes to choose from. Must not be empty.
    ///
    /// - Returns: A constant.
    static func responsive<T>(ofSizes sizes: [ResponsiveSizeClass: T]) -> T {
        switch ResponsiveSizeClass.value {
        case .small:
            return sizes[.small] ?? sizes[.medium] ?? sizes[.large]!
        case .medium:
            return sizes[.medium] ?? sizes[.small] ?? sizes[.large]!
        case .large:
            return sizes[.large] ?? sizes[.medium] ?? sizes[.small]!
        }
    }
}
