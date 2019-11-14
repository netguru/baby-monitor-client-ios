//
//  Spectrogram.swift
//  audio_ops
//
//  Created by Timo Rohner on 16/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import Accelerate

/**
 This class implements generating Spectrograms from linear pcm audio signals. It mirrors the tensorflow implementation (written in C++) (see: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/spectrogram.h)
 */
class SpectrogramOp: NSObject {
    
    enum SpectrogramOpError: Error {
        case parameterError(String)
        case computeError(String)
    }
    
    var stepLength: Int = 0
    var windowLength: Int = 0
    var fftLength: Int = 0
    var outputFrequencyChannels: Int = 0
    var initialized: Bool = false
    var scaleFactor: Float = 0.5

    var window: [Float]
    var inputReal: [Float]
    var inputImg: [Float]
    var fftReal: [Float]
    var fftImg: [Float]
    
    var samplesToNextStep: Int
    var fftSetup: vDSP_DFT_Setup?
    var magnitudeSquared: Bool = true

    /**
     Initializes a SpectrogramOp instance capable of computing a Spectrogram of a linear pcm audio signal.
     - Parameter windowLength: Window length to be used during Spectrogram computation
     - Parameter stepLength: Step length to be used during Spectrogram computation. A stepLength strictly smaller than windowLength results in window overlap.
     - Parameter magnituteSquared: Whether to calculate final magnitutdes of Spectrogram as L2 norm squared or normal L2 norm
     */
    init(windowLength: Int, stepLength: Int, magnitudeSquared: Bool) throws {
        self.windowLength = windowLength
        self.stepLength = stepLength
        self.magnitudeSquared = magnitudeSquared
        
        if self.windowLength < 2 {
            throw SpectrogramOpError.parameterError("windowLength has to be greater or equal to 2.")
        }
        
        if self.stepLength < 1 {
            throw SpectrogramOpError.parameterError("stepLength must be strictly positive")
        }
        
        fftLength = Int(UInt(self.windowLength).nextPowerOfTwo)
        window = [Float](repeating: 0.0, count: self.windowLength)
        
        inputReal = [Float](repeating: 0.0, count: fftLength / 2 + 1)
        inputImg = [Float](repeating: 0.0, count: fftLength / 2 + 1)
        
        fftReal = [Float](repeating: 0.0, count: fftLength / 2 + 1)
        fftImg = [Float](repeating: 0.0, count: fftLength / 2 + 1)

        vDSP_hann_window(&window, vDSP_Length(windowLength), Int32(vDSP_HANN_DENORM))
        
        samplesToNextStep = windowLength
        outputFrequencyChannels = 1 + fftLength / 2
        
        // Initialize FFT
        fftSetup = vDSP_DFT_zrop_CreateSetup(nil, vDSP_Length(fftLength), .FORWARD)
    }
    
    deinit {
        vDSP_DFT_DestroySetup(fftSetup)
    }
    
    /**
     Computes the spectrogram based on configuration of this Op instance on a given linear pcm audio signal
     - Parameter input: Pointer to Float (16bit/Half precision) values representing the raw linear pcm audio signal
     - Parameter inputLength: Number of raw linear pcm audio signal samples
     - Parameter output: Pointer to memory to be used to write the generated spectrogram. Has to be allocated by the caller of this method.
     */
    func compute(input: UnsafeMutablePointer<Float>,
                 inputLength: Int,
                 output: UnsafeMutablePointer<Float>) throws {
        
        let nTimebins = 1 + (inputLength - windowLength) / stepLength
        var nSamples = windowLength
        
        for i in 0..<nTimebins {
            // Fill full window if not enough samples for this window
            if inputLength - i * stepLength < windowLength {
                nSamples = inputLength - i * stepLength
            }
            for j in nSamples..<fftLength + 2 {
                if j % 2 == 0 {
                    inputReal[j / 2] = 0.0
                } else {
                    inputImg[(j - 1) / 2] = 0.0
                }
            }
            // Get input/output pointer for this window
            let samplesPtr = input.advanced(by: i * stepLength)
            let outputPtr = output.advanced(by: i * outputFrequencyChannels)
            
            // Multiply window with hanning window
            vDSP_vmul(samplesPtr, 2, &window, 2, &inputReal, 1, vDSP_Length(Int(ceil(Float(nSamples) / 2.0))))
            vDSP_vmul(samplesPtr.advanced(by: 1), 2, &window + 1, 2, &inputImg, 1, vDSP_Length(Int(floor(Float(nSamples) / 2.0))))

            // Execute Discrete Fourier transform
            vDSP_DFT_Execute(fftSetup!, &inputReal, &inputImg, &fftReal, &fftImg)
            // Set proper start/end for real/img outputs
            fftReal[fftLength / 2] = fftImg[0]
            fftImg[0] = 0.0
            fftImg[fftLength / 2] = 0.0
            
            // Scale by 0.5
            vDSP_vsmul(&fftReal, 1, &scaleFactor, &inputReal, 1, vDSP_Length(fftLength / 2 + 1))
            vDSP_vsmul(&fftImg, 1, &scaleFactor, &inputImg, 1, vDSP_Length(fftLength / 2 + 1))

            var dspSplit = DSPSplitComplex(realp: &inputReal, imagp: &inputImg)

            // Compute output values and write to output buffer
            if magnitudeSquared {
                vDSP_zvmags(&dspSplit, 1, outputPtr, 1, vDSP_Length(fftLength / 2 + 1))
            } else {
                vDSP_zvabs(&dspSplit, 1, outputPtr, 1, vDSP_Length(fftLength / 2 + 1))
            }
        }
    }
}
