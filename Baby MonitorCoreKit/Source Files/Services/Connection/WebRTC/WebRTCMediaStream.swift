//
//  WebRTCMediaStream.swift
//  Baby Monitor

import Foundation
import WebRCT

protocol WebRTCMediaStream: AnyObject {
    func enableAudioTrack()
    func disableAudioTrack()
}

extension RTCMediaStream: WebRTCMediaStream {
    func enableAudioTrack() {
        audioTracks.first?.isEnabled = true
    }

    func disableAudioTrack() {
        audioTracks.first?.isEnabled = false
    }
}
