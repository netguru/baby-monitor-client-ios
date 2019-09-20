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
    var cryingDetectionObservable: Observable<Bool> { get }
    
    /// Starts crying detection
    func startAnalysis()
    /// Stops crying detection
    func stopAnalysis()
}

final class CryingDetectionService: CryingDetectionServiceProtocol {
    
    lazy var cryingDetectionObservable = cryingDetectionSubject.asObservable()
    
    private let cryingDetectionSubject = PublishSubject<Bool>()
    
    private let microphoneCaptureService: AudioMicrophoneCaptureServiceProtocol?
    private let disposeBag = DisposeBag()
    private let audioprocessingModel = audioprocessing()
    private let crydetectionModel = crydetection()
    
    init(microphoneCaptureService: AudioMicrophoneCaptureServiceProtocol?) {
        self.microphoneCaptureService = microphoneCaptureService
        rxSetup()
    }
    
    func startAnalysis() {
        microphoneCaptureService?.startCapturing()
    }
    
    func stopAnalysis() {
        microphoneCaptureService?.stopCapturing()
    }
    
    private func rxSetup() {
        microphoneCaptureService?.microphoneBufferReadableObservable.subscribe(onNext: { [unowned self] bufferReadable in
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
                let babyCryingDetected: Bool = (Double(exactly: pred2.labels_softmax__0[1]) ?? 0) >= Constants.cryingDetectionThreshold
                self.cryingDetectionSubject.onNext(babyCryingDetected)
            } catch {
                print("ERROR")
            }
        }).disposed(by: disposeBag)
    }
}
