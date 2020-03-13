//
//  WebRTCMediaStreamMock.swift
//  Baby MonitorTests

import Foundation
@testable import BabyMonitor

final class WebRTCMediaStreamMock: WebRTCMediaStream {

    private(set) var didEnableAudioTrack = false
    private(set) var didDisableAudioTrack = false

    func enableAudioTrack() {
        didEnableAudioTrack = true
    }

    func disableAudioTrack() {
        didDisableAudioTrack = true
    }
}
