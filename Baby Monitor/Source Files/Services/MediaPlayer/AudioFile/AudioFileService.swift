//
//  AudioFileService.swift
//  Baby Monitor

import AVFoundation
import RxSwift

protocol AudioFileServiceProtocol: ErrorProducable {

    /// Create, save, and upload an audio file from input audio buffer.
    /// - Parameters:
    ///     - buffer: A buffer which should be converted and sent.
    ///     - audioRecordingURL: and URL to the recording folder locally.
    ///     - filePrefixName: a perfix of the audio files name.
    func uploadRecordingIfNeeded(from buffer: AVAudioPCMBuffer, audioRecordingURL: URL, filePrefixName: String)
}

/// Service which handles audio file creation, saving it locally and then sending it to the server.
final class AudioFileService: AudioFileServiceProtocol {

    enum AudioFileError: Error {
        case convertionToFileFailure
    }

    var errorObservable: Observable<Error> {
        return Observable.merge(audioFileStorage.errorObservable, audioBufferConverter.errorObservable, errorPublisher.asObservable())
    }
    private let storageService: StorageServerServiceProtocol
    private let audioFileStorage: AudioFileStorable
    private let audioBufferConverter: AudioBufferConvertable
    private let errorPublisher = PublishSubject<Error>()

    /// Initializes the audio file service.
    ///
    /// - Parameters:
    ///     - storageService: a service used for uploading files to the server.
    ///     - audioFileStorage: a storage for audio files locally.
    ///     - audioBufferConverter: converter from buffer to audio file.
    init(storageService: StorageServerServiceProtocol,
         audioFileStorage: AudioFileStorable,
         audioBufferConverter: AudioBufferConvertable) {
        self.storageService = storageService
        self.audioFileStorage = audioFileStorage
        self.audioBufferConverter = audioBufferConverter
    }

    /// Create, save, and upload an audio file from input audio buffer if recordings are allowed by user.
    /// - Parameter buffer: A buffer which should be converted and sent.
    func uploadRecordingIfNeeded(from buffer: AVAudioPCMBuffer, audioRecordingURL: URL, filePrefixName: String) {
        guard UserDefaults.isSendingCryingsAllowed else { return }
        guard let audioFile = audioBufferConverter.convertToFile(buffer: buffer, url: audioRecordingURL, filePrefixName: filePrefixName) else {
            Logger.error("Failed to create an audio file.")
            errorPublisher.onNext(AudioFileError.convertionToFileFailure)
            return
        }
        audioFileStorage.writeFile(audioFile, from: buffer, at: audioRecordingURL)
        storageService.uploadRecordingsToDatabaseIfAllowed()
    }
}
