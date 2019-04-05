//
//  MfccOp.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import Accelerate

/**
 This class implements calculating the Mel-frequency cepstrum coefficients from a spectrogram. It mirrors the tensorflow implementation (written in C++) (see: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc.h)
 */
class MfccOp {
    enum MfccOpError: Error {
        case evaluationError(String)
        case filterbankError(String)
        case mfccDctError(String)
        case accelerateDctError(String)
    }
    
    var initialized: Bool = false
    let upperFrequencyLimit: Double
    let lowerFrequencyLimit: Double
    let filterbankChannelCount: Int
    let dctCoefficientCount: Int
    var inputLength: Int = 0
    var inputSampleRate: Double = 0
    var kFilterbankFloor: Float = 1e-12
    var melFilterbank: MfccMelFilterbank?
    var dctSetup: vDSP_DFT_Setup?
    var mfccDct: MfccDct?
    
    private var useAccelerate: Bool = false
    
    /**
     Creates an instance of MfccOp and determines whether for the given configuration the Accelerate framework can be used to provide hardware accelerated computation.
     - Parameter upperFrequencyLimit: Upper Frequency limit used in the Mel frequency cepstrum computation
     - Parameter lowerFrequencyLimit: Lower Frequency limit used in the Mel frequency cepstrum computation
     - Parameter filterbankChannelCount: The number of filterbank Channels used in the Mel frequency cepstrum computation
     - Parameter dctCoefficientCount: The number of DCT (Discrete Cosine Transform) coefficients that should be used in the Mel frequency cepstrum computation
    */
    init(upperFrequencyLimit: Double,
         lowerFrequencyLimit: Double,
         filterbankChannelCount: Int,
         dctCoefficientCount: Int) {
        self.upperFrequencyLimit = upperFrequencyLimit
        self.lowerFrequencyLimit = lowerFrequencyLimit
        self.filterbankChannelCount = filterbankChannelCount
        self.dctCoefficientCount = dctCoefficientCount
        
        // Figure out whether we can use the fast vDSP DCT implementation or whether we have to use our own slower implementation
        // For vDSP to be available we need dctCoefficientCount to be equal to f * 2^n, where f is 1, 3, 5, or 15 and n >= 4
        // First we check whether dctCoefficientCount is a multiple of at least 2^4 via a bitwise and
        if (dctCoefficientCount == filterbankChannelCount) && (dctCoefficientCount & 15) == 0 {
            // It is indeed. We bitshift to remove 2^4 and then bitshift until we get an odd number.
            var shiftedDctCoefficientCount = dctCoefficientCount >> 4
            while (shiftedDctCoefficientCount & 1) == 0 {
                shiftedDctCoefficientCount = shiftedDctCoefficientCount >> 1
            }
            switch shiftedDctCoefficientCount {
            case 1, 3, 5, 15: useAccelerate = true
            default: useAccelerate = false
            }
        }
        
        // If we are able to make use of accelerate we set up the Discrete cosine transform using accelerate
        // Otherwise we make use of the non hardware accelerated DCT implementation that can be found in MfccDct.swift
        if useAccelerate {
            dctSetup = vDSP_DCT_CreateSetup(nil, vDSP_Length(dctCoefficientCount), vDSP_DCT_Type.II)
        } else {
            mfccDct = MfccDct()
        }
        // Initialize the filterbank
        melFilterbank = MfccMelFilterbank()
    }
    
    /**
     Initializes the operation by providing additional information needed for evaluation
     - Parameter inputLength: InputLength of the Spectrogram
     - Parameter inputSampleRate: The original sample rate of the audio that was passed to AudioSpectrogramLayer
     */
    func initialize(inputLength: Int, inputSampleRate: Double) throws {
        self.inputLength = inputLength
        self.inputSampleRate = inputSampleRate
        
        guard let melFilterbank = melFilterbank else {
            throw MfccOpError.filterbankError("melFilterbank unavailable")
        }
        
        try melFilterbank.initialize(inputLength: inputLength,
                                     inputSampleRate: inputSampleRate,
                                     outputChannelCount: filterbankChannelCount,
                                     lowerFrequencyLimit: lowerFrequencyLimit,
                                     upperFrequencyLimit: upperFrequencyLimit)
        
        if !useAccelerate {
            guard let mfccDct = mfccDct else {
                throw MfccOpError.mfccDctError("mfccDCT unavailable")
            }

            do {
                try mfccDct.initialize(inputLength: filterbankChannelCount,
                                       coefficientCount: dctCoefficientCount)
            } catch {
                throw MfccOpError.mfccDctError("mfccDct initialize failed")
            }
        }
        self.initialized = true
    }
    
    /**
     Computes the mel-frequency cepstrum coefficients for given input and writes it to output
     - Parameter input: Pointer to input spectrogram data for which to calculate the MFCCs
     - Parameter inputLength: Number of floats present in memory at location indicated by input
     - Parameter output: Pointer indicating where to write the computed MFCCs. Memory allocation is on the caller of this method.
     */
    func compute(input: UnsafeMutablePointer<Float>, inputLength: Int, output: UnsafeMutablePointer<Float>) throws {
        if !initialized {
            print("ERROR")
        }
        
        // Create needed temporary memory allocations
        var workingData1 = [Float](repeating: 0.0, count: filterbankChannelCount)
        var workingData2 = [Float](repeating: 0.0, count: filterbankChannelCount)
        var workingData3 = [Float](repeating: 0.0, count: filterbankChannelCount)
        
        // Compute filterbank
        melFilterbank!.compute(input: input, output: &workingData1)
        // Make sure we don't have negative or 0 values, because we're about to take the logarithm
        vDSP_vthr(&workingData1, 1, &kFilterbankFloor, &workingData2, 1, vDSP_Length(filterbankChannelCount))
        
        var nElements = Int32(filterbankChannelCount)
        // Take logarithm of filterbank evaluation
        vvlogf(&workingData3, &workingData2, &nElements)
        
        // Execute Discrete cosine transform using either accelerate or slower non-hardware accelerated implementation
        if useAccelerate {
            guard let dctSetup = dctSetup else {
                throw MfccOpError.accelerateDctError("vDSP_DCT_Execute not available")
            }
            
            var fnorm = sqrtf(2.0 / Float(filterbankChannelCount))
            // Multiply by fnorm to be in line with tensorflow implementation
            vDSP_vsmul(&workingData3, 1, &fnorm, &workingData2, 1, vDSP_Length(filterbankChannelCount))
            // Execute hardware accelerated (using Accelerate framework) DCT
            vDSP_DCT_Execute(dctSetup, &workingData2, output)
        } else {
            guard let mfccDct = mfccDct else {
                throw MfccOpError.mfccDctError("mfccDCT Op not available")
            }
            // Execute non-hardware accelerated DCT
            mfccDct.compute(input: &workingData3, output: output)
        }
    }
}
