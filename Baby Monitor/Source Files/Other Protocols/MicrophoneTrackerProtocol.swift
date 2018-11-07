//
//  MicrophoneTrackerProtocol.swift
//  Baby Monitor
//

import Foundation
import AudioKit

protocol MicrophoneTrackerProtocol: Any {
    /// Frequency that is get out of microphone
    var frequency: Double { get }
    
    /// Starts tracking
    func start()
    /// Stops tracking
    func stop()
}

extension AKMicrophoneTracker: MicrophoneTrackerProtocol {}
