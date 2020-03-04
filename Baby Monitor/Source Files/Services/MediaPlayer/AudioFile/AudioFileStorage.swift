//
//  AudioFileStorage.swift
//  Baby Monitor

import AVFoundation
import RxSwift

protocol AudioFileStorable: ErrorProducable {

    /// Save audio file from buffer locally.
    /// - Parameters:
    ///     - audioFile: File to save.
    ///     - buffer: A buffer from which file was created.
    ///     - url: An URL at which file should be saved.
    func writeFile(_ audioFile: AVAudioFile, from buffer: AVAudioPCMBuffer, at url: URL)
}

final class AudioFileStorage: AudioFileStorable {

    lazy var errorObservable = errorPublisher.asObservable()
    private let errorPublisher = PublishSubject<Error>()

    func writeFile(_ audioFile: AVAudioFile, from buffer: AVAudioPCMBuffer, at url: URL) {
           do {
               try audioFile.write(from: buffer)
           } catch {
               Logger.error("Failed to write an audio file.", error: error)
               errorPublisher.onNext(error)
           }
       }
}
