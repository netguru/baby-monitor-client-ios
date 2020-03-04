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
        var audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forWriting: url.appendingPathComponent(fileName), settings: outputFormatSettings, commonFormat: MachineLearningAudioConstants.audioFormat, interleaved: false)
            return audioFile
        } catch {
            Logger.error("Failed to create an audio file.", error: error)
            errorPublisher.onNext(error)
            return nil
        }
    }
    
}
