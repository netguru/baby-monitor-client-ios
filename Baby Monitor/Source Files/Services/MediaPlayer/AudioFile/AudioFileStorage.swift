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
        guard case .success = createRecordsFolderIfNeeded(for: url) else { return }
           do {
               try audioFile.write(from: buffer)
           } catch {
               Logger.error("Failed to write an audio file.", error: error)
               errorPublisher.onNext(error)
           }
       }

       private func createRecordsFolderIfNeeded(for url: URL) -> Result<Void> {
           guard !FileManager.default.fileExists(atPath: url.path) else {
                return .success(())
           }
           do {
               try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            return .success(())
           } catch {
               errorPublisher.onNext(error)
               Logger.error("Failed to create directory.", error: error)
            return .failure(error)
           }
       }
}
