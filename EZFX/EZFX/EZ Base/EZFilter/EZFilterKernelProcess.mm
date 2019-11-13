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
        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float outputLevel = EZKernelBase::outputLevel;
        float rampedXValue = 0;
        float rampedYValue = 0;
        float rampedOutputLevel = 0;
        float rampedLFOMod = 0;
        float rampedLFORate = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        sp_port_compute(sp, lfoModInternalRamper, &lfoMod, &rampedLFOMod);
        sp_port_compute(sp, lfoRateInternalRamper, &lfoRate, &rampedLFORate);
        
        float xPos = rampedXValue;
        float yPos = rampedYValue;
        float xValExp = expValue(xPos, 3);
       // float dFromO = distanceFromOrigin(xPos, yPos);
        
        lfoPhasor->freq = rampedLFORate + 0.001f;
        
        float phasorOut = 0;
        sp_phasor_compute(sp, lfoPhasor, nil, &phasorOut);
        float filterMod = sin(phasorOut * M_PI) * (rampedLFOMod * 1000);
        
        float fFreq = (22100.0f * xValExp) + filterMod;
        filterL->freq = fFreq;//5000.0f * powf(lfoOne, 4);
        filterR->freq = fFreq;//5000.0f * powf(lfoOne, 4);
        
        filterL->res = yPos;
        filterR->res = yPos;
        
        float filterOutL, filterOutR = 0;

        
        sp_moogladder_compute(sp, filterL, &mainInL, &filterOutL);
        sp_moogladder_compute(sp, filterR, &mainInR, &filterOutR);
        
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
