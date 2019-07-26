//
//  AudioMicrophoneCaptureServiceProtocol.swift
//  Baby Monitor
//

import AVFoundation
import RxSwift

protocol AudioMicrophoneCaptureServiceProtocol {
    var microphoneBufferReadableObservable: Observable<AVAudioPCMBuffer> { get }
    var isCapturing: Bool { get }
    
    func stopCapturing()
    func startCapturing()
}