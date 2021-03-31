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
 This class adds functionality to Apple's coreML in the form of a Custom Layer that allows computing the Spectrogram of a half precision linear pcm audio signal
 */
@objc(AudioSpectrogramLayer) class AudioSpectrogramLayer: NSObject, MLCustomLayer {
    
    enum AudioSpectrogramLayerError: Error {
        case parameterError
    }
    
    let windowSize: Int
    let stride: Int
    let magnitudeSquared: Bool
    let outputChannels: NSNumber
    let spectogramOp: SpectrogramOp
    
    /**
     Initializes instance of AudioSpectrogramLayer with given parameters from the .mlmodel protobufs
     - Parameter parameters: parameters as defined in the protobuf files of the coreml .mlmodel binary file
     */
    required init(parameters: [String: Any]) throws {
        guard let windowSize = parameters["window_size"] as? Int,
            let stride = parameters["stride"] as? Int,
            let magnitudeSquared = parameters["magnitude_squared"] as? Bool else {
                throw AudioSpectrogramLayerError.parameterError
        }
        self.windowSize = windowSize
        self.stride = stride
        self.magnitudeSquared = magnitudeSquared
        
        outputChannels = NSNumber(value: 1 + UInt(self.windowSize).nextPowerOfTwo / 2)
        spectogramOp = try SpectrogramOp(windowLength: Int(windowSize),
                                         stepLength: Int(stride),
                                         magnitudeSquared: magnitudeSquared)
        super.init()
    }
    
    /**
     Serves no purpose, since this layer has no associated weights.
     */
    func setWeightData(_ weights: [Data]) throws {
        // No weight data for this layer
    }
    
    /**
     Computes the predicted output shapes for a given input shapes according to the following formula:
     [1, 1, NUM_SAMPLES, 1, 1] => [1, 1, 1, 1 + (NUM_SAMPLES - self.windowSize) / self.stride, self.outputChannels],
     where NUM_SAMPLES is the number of samples of the audio signal and self.windowSize, self.stride, self.outputChannels are given by parameters during initialization of the AudioSpectrogramLayer instance.
     - Parameter inputShapes: inputShapes for which to calculate output shapes
     - Returns: outputShapes for given inputShapes
     */
    func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        var outputShapesArray = [[NSNumber]]()
        let inputLength = Int(truncating: inputShapes[0][2])
        let outputLength = NSNumber(value: 1 + (inputLength - self.windowSize) / self.stride)
        outputShapesArray.append([1, 1, 1, outputLength, outputChannels])
        return outputShapesArray
    }
    
    /**
     Evaluate the layer for a given set of inputs and write result to a given set of outputs
     - Parameter inputs: Array of MLMultiArray instances, each representing 1 input to be evaluated.
     - Parameter outputs: Array of MLMultiArray instances, each representing 1 output into which the evaluation of the corresponding input is written.
     */
    func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        try spectogramOp.compute(input: UnsafeMutablePointer<Float>(OpaquePointer(inputs[0].dataPointer)),
                                 inputLength: inputs[0].count,
                                 output: UnsafeMutablePointer<Float>(OpaquePointer(outputs[0].dataPointer)))
    }
}
