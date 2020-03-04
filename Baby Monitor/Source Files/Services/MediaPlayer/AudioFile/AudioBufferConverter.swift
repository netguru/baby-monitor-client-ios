//
//  AudioBufferConverter.swift
//  Baby Monitor

import AVFoundation
import RxSwift

protocol AudioBufferConvertable: ErrorProducable {

    /// Create an audio file from input audio buffer.
    /// - Parameters:
    ///     - buffer: A buffer which should be converted and sent.
    ///     - url: An URL at which file will be saved.
    ///     - filePrefixName: A prefix of a future file name.
    func convertToFile(buffer: AVAudioPCMBuffer, url: URL, filePrefixName: String) -> AVAudioFile?
}

final class AudioBufferConverter: AudioBufferConvertable {

    enum AudioBufferConverterError: Error {
        case convertionToFileFailure
    }

    lazy var errorObservable = errorPublisher.asObservable()
    private let errorPublisher = PublishSubject<Error>()

    func convertToFile(buffer: AVAudioPCMBuffer, url: URL, filePrefixName: String) -> AVAudioFile? {
        let fileNameSuffix = DateFormatter.fullTimeFormatString(breakCharacter: "_")
        let outputFormatSettings: [String: Any] = [
            AVLinearPCMBitDepthKey: MachineLearningAudioConstants.bitDepthKey,
            AVLinearPCMIsFloatKey: MachineLearningAudioConstants.isFloat,
            AVSampleRateKey: MachineLearningAudioConstants.sampleRate,
            AVNumberOfChannelsKey: MachineLearningAudioConstants.channels
        ]
        let fileName = filePrefixName.appending(fileNameSuffix).appending(MachineLearningAudioConstants.recordingFileFormat)
        let audioURL = url.appendingPathComponent(fileName)
        guard case .success = createRecordsFolderIfNeeded(for: url) else { return nil }
        var audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forWriting: audioURL, settings: outputFormatSettings, commonFormat: MachineLearningAudioConstants.audioFormat, interleaved: false)
            return audioFile
        } catch {
            Logger.error("Failed to create an audio file.", error: error)
            errorPublisher.onNext(error)
            return nil
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
