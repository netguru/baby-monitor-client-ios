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

@objc(AudioSpectrogramLayer) class AudioSpectrogramLayer: NSObject, MLCustomLayer {
    
    enum AudioSpectrogramLayerError: Error {
        case parameterError(String)
        case evaluateError(String)
    }
    
    let windowSize: Int
    let stride: Int
    let magnitudeSquared: Bool
    let outputChannels: NSNumber
    let spectogramOp: SpectrogramOp
    
    required init(parameters: [String: Any]) throws {
        guard let windowSize = parameters["window_size"] as? Int else {
            throw AudioSpectrogramLayerError.parameterError("window_size")
        }
        self.windowSize = windowSize
        
        guard let stride = parameters["stride"] as? Int else {
            throw AudioSpectrogramLayerError.parameterError("stride")
        }
        self.stride = stride
        
        guard let magnitudeSquared = parameters["magnitude_squared"] as? Bool else {
            throw AudioSpectrogramLayerError.parameterError("magnitude_squared")
        }
        self.magnitudeSquared = magnitudeSquared
        
        outputChannels = NSNumber(value: 1 + MathUtils.nextPowerOfTwo(self.windowSize) / 2)
        spectogramOp = try SpectrogramOp(windowLength: windowSize,
                                         stepLength: stride,
                                         magnitudeSquared: magnitudeSquared)
        super.init()
    }
    
    func setWeightData(_ weights: [Data]) throws {
        // No weight data for this layer
    }
    
    func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        // Input shape is [1,1,NUM_SAMPLES, 1,1]
        // This gives us the output shape
        // [1,1,1,N_TIME_BINS, N_FREQUENCY_BINS]
        var outputShapesArray = [[NSNumber]]()
        let inputLength = Int(truncating: inputShapes[0][2])
        let outputLength = NSNumber(value: 1 + (inputLength - self.windowSize) / self.stride)
        outputShapesArray.append([1, 1, 1, outputLength, outputChannels])
        print("AudioSpectrogramLayer: ", #function, inputShapes, " -> ", outputShapesArray)
        return outputShapesArray
    }
    
    func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        try spectogramOp.compute(input: UnsafeMutablePointer<Float>(OpaquePointer(inputs[0].dataPointer)),
                                 inputLength: inputs[0].count,
                                 output: UnsafeMutablePointer<Float>(OpaquePointer(outputs[0].dataPointer)))
    }
}

// Audio OPS
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/ops/audio_ops.cc

// AUDIOSPECTROGRAM
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/spectrogram_op.cc
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/spectrogram.h
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/spectrogram.cc

// MFCC
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc.cc
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc.h
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_dct.cc
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_dct.h
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_mel_filterbank.cc
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_mel_filterbank.h
// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_op.cc
