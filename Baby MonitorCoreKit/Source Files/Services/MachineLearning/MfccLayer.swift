//
//  AudioSpectrogram.swift
//  audio_ops
//
//  Created by Timo Rohner on 15/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import CoreML
import Accelerate

/**
 This class adds functionality to Apple's coreML in the form of a Custom Layer that allows computing the Mel frequency cepstrum for a spectrogram computed for a given linear pcm audio signal
 */
@objc(MfccLayer) class MfccLayer: NSObject, MLCustomLayer {
    enum MfccLayerError: Error {
        case parameterError(String)
        case opError(String)
        case evaluationError(String)
    }
    
    let upperFrequencyLimit: Double
    let lowerFrequencyLimit: Double
    let filterbankChannelCount: Int
    let dctCoefficientCount: Int
    let sampleRate: Double
    var mfccOp: MfccOp?
    
    /**
     Initializes instance of MfccLayer with given parameters from the .mlmodel protobufs
     - Parameter parameters: parameters as defined in the protobuf files of the coreml .mlmodel binary file
     */
    required init(parameters: [String: Any]) throws {
        guard let sampleRate = parameters["sample_rate"] as? Double else {
            throw MfccLayerError.parameterError("sample_rate")
        }
        self.sampleRate = sampleRate
        
        guard let upperFrequencyLimit = parameters["upper_frequency_limit"] as? Double else {
            throw MfccLayerError.parameterError("upper_frequency_limit")
        }
        self.upperFrequencyLimit = upperFrequencyLimit
        
        guard let lowerFrequencyLimit = parameters["lower_frequency_limit"] as? Double else {
            throw MfccLayerError.parameterError("lower_frequency_limit")
        }
        self.lowerFrequencyLimit = lowerFrequencyLimit
        
        guard let filterbankChannelCount = parameters["filterbank_channel_count"] as? Int else {
            throw MfccLayerError.parameterError("filterbank_channel_count")
        }
        self.filterbankChannelCount = filterbankChannelCount
       
        guard let dctCoefficientCount = parameters["dct_coefficient_count"] as? Int else {
            throw MfccLayerError.parameterError("dct_coefficient_count")
        }
        self.dctCoefficientCount = dctCoefficientCount
        
        mfccOp = MfccOp(upperFrequencyLimit: upperFrequencyLimit,
                        lowerFrequencyLimit: lowerFrequencyLimit,
                        filterbankChannelCount: filterbankChannelCount,
                        dctCoefficientCount: dctCoefficientCount)
        
        guard let mfccOp = mfccOp else {
            throw MfccLayerError.opError("MfccOp init failed for given parameters")
        }
        try mfccOp.initialize(inputLength: 1025, inputSampleRate: sampleRate)

        super.init()
    }
    
    /**
     Serves no purpose, since this layer has no associated weights.
     */
    func setWeightData(_ weights: [Data]) throws {
        // No weight data in this layer
    }
    
    /**
     Computes the predicted output shapes for a given input shapes according to the following formula:
     [1, 1, 1, N_TIME_BINS, N_FREQUENCY_BINS] => [1, 1, 1, N_TIME_BINS, self.dctCoefficientCount],
     where self.self.dctCoefficientCount is given by parameters during initialization of the MfccLayer instance.
     - Parameter inputShapes: inputShapes for which to calculate output shapes
     - Returns: outputShapes for given inputShapes
     */
    func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        var outputShapesArray = [[NSNumber]]()
        outputShapesArray.append([1, 1, 1, inputShapes[0][3], NSNumber(value: dctCoefficientCount)])
        return outputShapesArray
    }
    
    /**
     Evaluate the layer for a given set of inputs and write result to a given set of outputs
     - Parameter inputs: Array of MLMultiArray instances, each representing 1 input to be evaluated.
     - Parameter outputs: Array of MLMultiArray instances, each representing 1 output into which the evaluation of the corresponding input is written.
     */
    func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        let nSpectrogramSamples = Int(truncating: inputs[0].shape[3])
        let nSpectrogramChannels = Int(truncating: inputs[0].shape[4])
        
        let ptrSpectrogramInput = UnsafeMutablePointer<Float>(OpaquePointer(inputs[0].dataPointer))
        let ptrOutput = UnsafeMutablePointer<Float>(OpaquePointer(outputs[0].dataPointer))

        for spectrogramIndex in 0..<nSpectrogramSamples {
            let inputPointer = ptrSpectrogramInput.advanced(by: spectrogramIndex * nSpectrogramChannels)
            let outputPointer = ptrOutput.advanced(by: spectrogramIndex * dctCoefficientCount)
            try mfccOp!.compute(input: inputPointer, inputLength: nSpectrogramChannels, output: outputPointer)
        }
    }
}
