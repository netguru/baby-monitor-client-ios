//
//  CryingDetectionService.swift
//  Baby Monitor
//

import Foundation
import CoreML
import AudioKit
import RxSwift
import RxCocoa

protocol CryingDetectionServiceProtocol: Any {
    
    /// Observable that informs about detection of baby's cry
    var cryingDetectionObservable: Observable<CryingDetectionResult> { get }

    /// Predicts a baby cry.
    func predict(on bufferReadable: AVAudioPCMBuffer)
}

/// A result whether crying was detected.
struct CryingDetectionResult {
    /// Indicates whether baby is crying or not.
    let isBabyCrying: Bool
    /// Propability which machine learning returns for baby crying.
    let probability: Double
    /// An audio buffer on which the prediction was made.
    let buffer: AVAudioPCMBuffer
}

final class CryingDetectionService: CryingDetectionServiceProtocol {
    
    lazy var cryingDetectionObservable = cryingDetectionSubject.asObservable()
    
    private let cryingDetectionSubject = PublishSubject<CryingDetectionResult>()

    private let disposeBag = DisposeBag()
    private let audioprocessingModel = audioprocessing()
    private let crydetectionModel = crydetection()

    func predict(on bufferReadable: AVAudioPCMBuffer) {
        do {
            let audioProcessingMultiArray = try MLMultiArray(dataPointer: bufferReadable.floatChannelData!.pointee,
                                                             shape: [264600],
                                                             dataType: .float32,
                                                             strides: [1])
            let audioProcessingInput = audioprocessingInput(raw_audio__0: audioProcessingMultiArray)
            let audioProcessingPrediction = try self.audioprocessingModel.prediction(input: audioProcessingInput)
            let crydetectionMultiArray = try MLMultiArray(shape: [1, 1, 1, 598, 64], dataType: .float32)
            crydetectionMultiArray.dataPointer.copyMemory(from: audioProcessingPrediction.Mfcc__0.dataPointer, byteCount: 38272 * 4)
            let cryDetectionInput = crydetectionInput(Mfcc__0: crydetectionMultiArray)
            let cryDetectionPrediction = try self.crydetectionModel.prediction(input: cryDetectionInput)
            let cryingProbability = Double(exactly: cryDetectionPrediction.labels_softmax__0[1]) ?? 0
            let babyCryingDetected = cryingProbability >= Constants.cryingDetectionThreshold
            self.cryingDetectionSubject.onNext(CryingDetectionResult(isBabyCrying: babyCryingDetected, probability: cryingProbability, buffer: bufferReadable))
        } catch {
            Logger.error("Crying detection failed - audioProcessingMultiArray exeption", error: error)
        }
    }
}
