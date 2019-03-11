//
//  MfccOp.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import Accelerate

enum MfccOpError :Error {
    case stringerror(String)
}

class MfccOp {
    var initialized:Bool = false
    let upperFrequencyLimit:Double
    let lowerFrequencyLimit:Double
    let filterbankChannelCount:Int
    let dctCoefficientCount:Int
    var inputLength:Int = 0
    var inputSampleRate:Double = 0
    var kFilterbankFloor:Float = 1e-12
    //var mfcc_dct:MfccDct?
    var melFilterbank:MfccMelFilterbank?
    var dctSetup:vDSP_DFT_Setup?
    
    
    init(upperFrequencyLimit:Double,
         lowerFrequencyLimit:Double,
         filterbankChannelCount:Int,
         dctCoefficientCount:Int) {
        self.upperFrequencyLimit = upperFrequencyLimit
        self.lowerFrequencyLimit = lowerFrequencyLimit
        self.filterbankChannelCount = filterbankChannelCount
        self.dctCoefficientCount = dctCoefficientCount
        //mfcc_dct = MfccDct()
    }
    
    func initialize(inputLength: Int, inputSampleRate: Double) throws {
        dctSetup = vDSP_DCT_CreateSetup(nil, vDSP_Length(dctCoefficientCount), vDSP_DCT_Type.II)
        self.inputLength = inputLength
        self.inputSampleRate = inputSampleRate
        
        melFilterbank = MfccMelFilterbank()
        if(!melFilterbank!.initialize(inputLength: inputLength, inputSampleRate: inputSampleRate, outputChannelCount: filterbankChannelCount, lowerFrequencyLimit: lowerFrequencyLimit, upperFrequencyLimit: upperFrequencyLimit)) {
            throw MfccOpError.stringerror("err")
        }
        
        //try mfcc_dct!.Initialize(input_length: filterbank_channel_count_, coefficient_count: dct_coefficient_count_)

        self.initialized = true
    }
    
    func compute(input: UnsafeMutablePointer<Float>, inputLength: Int, output: UnsafeMutablePointer<Float>) throws {
        if(!initialized) {
            print("ERROR")
        }
        var workingData1 = [Float](repeating: 0.0, count: filterbankChannelCount)
        var workingData2 = [Float](repeating: 0.0, count: filterbankChannelCount)
        var workingData3 = [Float](repeating: 0.0, count: filterbankChannelCount)
        melFilterbank!.compute(input: input, output: &workingData1)
        vDSP_vthr(&workingData1, 1, &kFilterbankFloor, &workingData2, 1, vDSP_Length(filterbankChannelCount))
        
        var nElements = Int32(filterbankChannelCount)
        vvlogf(&workingData3, &workingData2, &nElements)
        
        // Execute DCT
        var fnorm = sqrtf(2.0 / Float(64))
        vDSP_vsmul(&workingData3, 1, &fnorm, &workingData2, 1, vDSP_Length(64))
        vDSP_DCT_Execute(dctSetup!, &workingData2, output)
        //mfcc_dct!.Compute(input: &working_data3, output: output)
    }
}
