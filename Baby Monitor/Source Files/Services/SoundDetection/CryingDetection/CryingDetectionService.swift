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

struct CryingDetectionResult {
    let isBabyCrying: Bool
    let probability: Double
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
            let input = audioprocessingInput(raw_audio__0: audioProcessingMultiArray)
            let pred = try self.audioprocessingModel.prediction(input: input)
            let crydetectionMultiArray = try MLMultiArray(shape: [1, 1, 1, 598, 64], dataType: .float32)
            crydetectionMultiArray.dataPointer.copyMemory(from: pred.Mfcc__0.dataPointer, byteCount: 38272 * 4)
            let input1 = crydetectionInput(Mfcc__0: crydetectionMultiArray)
            let pred2 = try self.crydetectionModel.prediction(input: input1)
            let cryingProbability = Double(exactly: pred2.labels_softmax__0[1]) ?? 0
            let babyCryingDetected: Bool = cryingProbability >= Constants.cryingDetectionThreshold
            self.cryingDetectionSubject.onNext(CryingDetectionResult(isBabyCrying: babyCryingDetected, probability: cryingProbability))
        } catch {
            Logger.error("Crying detection failed - audioProcessingMultiArray exeption", error: error)
        }
    }
}
