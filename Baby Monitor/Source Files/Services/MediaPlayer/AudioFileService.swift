//
//  AudioFileService.swift
//  Baby Monitor

import AVFoundation
import RxSwift

protocol AudioFileServiceProtocol: ErrorProducable {

    /// Create, save, and upload an audio file from input audio buffer.
    /// - Parameter buffer: A buffer which should be converted and sent.
    func uploadRecordingIfNeeded(from buffer: AVAudioPCMBuffer)
}

/// Service which handles audio file creation, saving it locally and then sending it to the server.
final class AudioFileService: AudioFileServiceProtocol {

    enum AudioFileError: Error {
        case convertionToFileFailure
    }

    lazy var errorObservable = errorPublisher.asObservable()
    private let storageService: StorageServerServiceProtocol
    private let recordingURL: URL
    private let filePrefixName: String
    private let errorPublisher = PublishSubject<Error>()

    /// Initializes the audio file service.
    ///
    /// - Parameters:
    ///     - storageService: a service used for uploading files to the server.
    ///     - audioRecordingURL: and URL to the recording folder locally.
    ///     - filePrefixName: a perfix of the audio files name.
    init(storageService: StorageServerServiceProtocol,
         audioRecordingURL: URL = FileManager.cryingRecordsURL,
         filePrefixName: String = "crying_") {
        self.storageService = storageService
        self.recordingURL = audioRecordingURL
        self.filePrefixName = filePrefixName
    }

    /// Create, save, and upload an audio file from input audio buffer if recordings are allowed by user.
    /// - Parameter buffer: A buffer which should be converted and sent.
    func uploadRecordingIfNeeded(from buffer: AVAudioPCMBuffer) {
        guard UserDefaults.isSendingCryingsAllowed else { return }
        guard let audioFile = convertToFile(buffer: buffer) else {
            Logger.error("Failed to create an audio file.")
            errorPublisher.onNext(AudioFileError.convertionToFileFailure)
            return
        }
        writeFile(audioFile, from: buffer)
        storageService.uploadRecordingsToDatabaseIfAllowed()
    }

    private func convertToFile(buffer: AVAudioPCMBuffer) -> AVAudioFile? {
        let fileNameSuffix = DateFormatter.fullTimeFormatString(breakCharacter: "_")
        let outputFormatSettings: [String: Any] = [
            AVLinearPCMBitDepthKey: MachineLearningAudioConstants.bitDepthKey,
            AVLinearPCMIsFloatKey: MachineLearningAudioConstants.isFloat,
            AVSampleRateKey: MachineLearningAudioConstants.sampleRate,
            AVNumberOfChannelsKey: MachineLearningAudioConstants.channels
        ]
        let fileName = filePrefixName.appending(fileNameSuffix).appending(".wav")
        var audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forWriting: recordingURL.appendingPathComponent(fileName), settings: outputFormatSettings, commonFormat: MachineLearningAudioConstants.audioFormat, interleaved: false)
            return audioFile
        } catch {
            Logger.error("Failed to create an audio file.", error: error)
            errorPublisher.onNext(error)
            return nil
        }
    }

    private func writeFile(_ audioFile: AVAudioFile, from buffer: AVAudioPCMBuffer) {
        createRecordsFolderIfNeeded()
        do {
            try audioFile.write(from: buffer)
        } catch {
            Logger.error("Failed to write an audio file.", error: error)
            errorPublisher.onNext(error)
        }
    }

    private func createRecordsFolderIfNeeded() {
        guard !FileManager.default.fileExists(atPath: recordingURL.path) else {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: recordingURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            Logger.error("Failed to create directory.", error: error)
        }
    }

}
