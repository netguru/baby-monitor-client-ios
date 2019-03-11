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

enum MfccLayerError: Error {
    case parameterError(String)
    case evaluationError(String)
}

@objc(MfccLayer) class MfccLayer: NSObject, MLCustomLayer {
    let upperFrequencyLimit: Double
    let lowerFrequencyLimit: Double
    let filterbankChannelCount: Int
    let dctCoefficientCount: Int
    let sampleRate: Double
    var mfccOp: MfccOp?
    
    required init(parameters: [String: Any]) throws {
        print(#function, parameters)
        if let sampleRate = parameters["sample_rate"] as? Double {
            self.sampleRate = sampleRate
        } else {
            throw MfccLayerError.parameterError("sample_rate")
        }
        if let upperFrequencyLimit = parameters["upper_frequency_limit"] as? Double {
            self.upperFrequencyLimit = upperFrequencyLimit
        } else {
            throw MfccLayerError.parameterError("upper_frequency_limit")
        }
        
        if let lowerFrequencyLimit = parameters["lower_frequency_limit"] as? Double {
            self.lowerFrequencyLimit = lowerFrequencyLimit
        } else {
            throw MfccLayerError.parameterError("lower_frequency_limit")
        }
        
        if let filterbankChannelCount = parameters["filterbank_channel_count"] as? Int {
            self.filterbankChannelCount = filterbankChannelCount
        } else {
            throw MfccLayerError.parameterError("filterbank_channel_count")
        }
       
        if let dctCoefficientCount = parameters["dct_coefficient_count"] as? Int {
            self.dctCoefficientCount = dctCoefficientCount
        } else {
            throw MfccLayerError.parameterError("dct_coefficient_count")
        }
        
        mfccOp = MfccOp(upperFrequencyLimit: upperFrequencyLimit,
                        lowerFrequencyLimit: lowerFrequencyLimit,
                        filterbankChannelCount: filterbankChannelCount,
                        dctCoefficientCount: dctCoefficientCount)
        try mfccOp!.initialize(inputLength: 1025, inputSampleRate: sampleRate)

        super.init()
    }
    
    func setWeightData(_ weights: [Data]) throws {
        print(#function, weights)
        
    }
    
    func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        // Input shape is [1,1,1,N_TIME_BINS, N_FREQUENCY_BINS]
        // This gives us the output shape
        // [1,1,N_TIME_BINS, dct_coefficient_count]
        var outputShapesArray = [[NSNumber]]()
        
        outputShapesArray.append([1, 1, 1, inputShapes[0][3], NSNumber(value: dctCoefficientCount)])
        print("MfccLayer: ", #function, inputShapes, " -> ", outputShapesArray)
        return outputShapesArray
    }
    
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
