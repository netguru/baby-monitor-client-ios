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
    
    private var isCryingEventDetected = false
    private let microphoneCapture: AudioMicrophoneCaptureServiceProtocol?
    private let disposeBag = DisposeBag()
    private let audioprocessingModel = audioprocessing()
    private let crydetectionModel = crydetection()
    
    init(microphoneCapture: AudioMicrophoneCaptureServiceProtocol?) {
        self.microphoneCapture = microphoneCapture
        rxSetup()
    }
    
    func startAnalysis() {
        microphoneCapture?.startCapturing()
    }
    
    func stopAnalysis() {
        microphoneCapture?.stopCapturing()
    }
    
    private func rxSetup() {
        microphoneCapture?.microphoneBufferReadableObservable.subscribe(onNext: { [unowned self] bufferReadable in
            do {
            print("RUNNING ML MODEL")
            let audioProcessingMultiArray = try MLMultiArray(dataPointer: bufferReadable.floatChannelData!.pointee, shape: [264600], dataType: .float32, strides: [1])

            let input = audioprocessingInput(raw_audio__0: audioProcessingMultiArray)
            let pred = try self.audioprocessingModel.prediction(input: input)
            let crydetectionMultiArray = try MLMultiArray(shape: [1, 1, 1, 598, 64], dataType: .float32)
            crydetectionMultiArray.dataPointer.copyMemory(from: pred.Mfcc__0.dataPointer, byteCount: 38272 * 4)
            let input1 = crydetectionInput(Mfcc__0: crydetectionMultiArray)
            let pred2 = try self.crydetectionModel.prediction(input: input1)
            print(pred2.labels_softmax__0)
            
            self.cryingDetectionSubject.onNext(false)
            } catch {
                print("ERROR")
            }
        }).disposed(by: disposeBag)
    }
}
