//
//  EZFilterKernelProcess.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZFilterKernel.hpp"

void EZFilterKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    getAndSteps();
   
    if (EZKernelBase::isActive == 0) {
        for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
            outL[i] = inL[i];
            outR[i] = inR[i];
            calculateAmplitudes(outL[i], outR[i]);
        }
        resetFX();
        return;
    } else {
        fxResetted = false;
    }
    
    for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float outputLevel = EZKernelBase::outputLevel;
        float rampedXValue = 0;
        float rampedYValue = 0;
        float rampedInputLevel = 0;
        float rampedOutputLevel = 0;
        float rampedLFOMod = 0;
        float rampedLFORate = 0;
        
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        sp_port_compute(sp, internalInputLevelRamper, &inputLevel, &rampedInputLevel);
        sp_port_compute(sp, lfoModInternalRamper, &lfoMod, &rampedLFOMod);
        sp_port_compute(sp, lfoRateInternalRamper, &lfoRate, &rampedLFORate);
        
        float xPos = clamp(rampedXValue, 0.001f, 0.999f);
        float yPos = clamp(rampedYValue, 0.001f, 0.999f);
        float xValExp = clamp(expValue(xPos, 3), 0.001f, 0.999f);
       // float dFromO = distanceFromOrigin(xPos, yPos);
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float inputLevelOutL = mainInL * rampedInputLevel;
        float inputLevelOutR = mainInR * rampedInputLevel;
        
        float inputSaturatorOutL, inputSaturatorOutR;
        sp_saturator_compute(sp, inputSaturatorL, &inputLevelOutL, &inputSaturatorOutL);
        sp_saturator_compute(sp, inputSaturatorR, &inputLevelOutR, &inputSaturatorOutR);
        
        lfoPhasor->freq = rampedLFORate + 0.001f;
        
        float phasorOut = 0;
        sp_phasor_compute(sp, lfoPhasor, nil, &phasorOut);
        float filterMod = sin(phasorOut * M_PI) * (rampedLFOMod * 1000);
        
        float fFreq = (20000 * xValExp) + filterMod;
        
        //Low pass
        lpfL->freq = fFreq;//5000.0f * powf(lfoOne, 4);
        lpfR->freq = fFreq;//5000.0f * powf(lfoOne, 4);
        
        lpfL->res = yPos;
        lpfR->res = yPos;
        
        float lpfFilterOutL, lpfFilterOutR = 0;

        sp_moogladder_compute(sp, lpfL, &inputSaturatorOutL, &lpfFilterOutL);
        sp_moogladder_compute(sp, lpfR, &inputSaturatorOutR, &lpfFilterOutR);
        
        //Band pass
        bwL->freq = fFreq;
        bwR->freq = fFreq;
        bwL->bw = (501 - yPos * 500);
        bwR->bw = (501 - yPos * 500);
        
        float bwOutL, bwOutR;
        sp_reson_compute(sp, bwL, &inputSaturatorOutL, &bwOutL);
        sp_reson_compute(sp, bwR, &inputSaturatorOutR, &bwOutR);
        //gain issue
        bwOutL *= 0.001;
        bwOutR *= 0.001;
        
        //Highpass
        
        hpfL->freq = fFreq;
        hpfR->freq = fFreq;
        
        float hpfOutL, hpfOutR;
        
        sp_buthp_compute(sp, hpfL, &inputSaturatorOutL, &hpfOutL);
        sp_buthp_compute(sp, hpfR, &inputSaturatorOutR, &hpfOutR);
        
        
        //string
        
        stringL->freq = fFreq;
        stringR->freq = fFreq;
        stringL->fdbgain = yPos;
        stringR->fdbgain = yPos;
        
        float stringOutL, stringOutR;
        
        sp_streson_compute(sp, stringL, &inputSaturatorOutL, &stringOutL);
        sp_streson_compute(sp, stringR, &inputSaturatorOutR, &stringOutR);
        //303
        
       
        lpf35L->cutoff = lpf35R->cutoff = fFreq;
        lpf35L->res = lpf35R->res = yPos * 2;
        lpf35L->saturation = lpf35R->saturation = 0.5 + yPos ;
        
        float lpf2OutL, lpf2OutR;
        
        sp_wpkorg35_compute(sp, lpf35L, &inputSaturatorOutL, &lpf2OutL);
        sp_wpkorg35_compute(sp, lpf35R, &inputSaturatorOutR, &lpf2OutR);
    
        //switch
        float filterOutL, filterOutR;
        
        switch (filterType) {
            case 0:
                filterOutL = lpfFilterOutL;
                filterOutR = lpfFilterOutR;
                break;
            case 1:
                filterOutL = lpf2OutL;
                filterOutR = lpf2OutR;
                break;
            case 2:
                filterOutL = stringOutL;
                filterOutR = stringOutR;
                break;
            case 3:
                filterOutL = bwOutL;
                filterOutR = bwOutR;
                break;
            case 4:
                filterOutL = hpfOutL;
                filterOutR = hpfOutR;
                break;
            default:
                filterOutL = 0;
                filterOutR = 0;
        };
        
        filterOutL *= rampedOutputLevel;
        filterOutR *= rampedOutputLevel;
        
        float mainOutL, mainOutR;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &filterOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &filterOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
        
    }
};
