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
    
    EZKernelBase::standardEZFXGetAndSteps();
    float xPos = EZKernelBase::xValue - 0.5;
    float yPos = EZKernelBase::yValue - 0.5;
    float dFromO = distanceFromOrigin(xPos, yPos);
    
    lfoPhasor->freq = dFromO * 10.0f + 1.0f;
    
    if (EZKernelBase::isActive == 0) {
        for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
            outL[i] = inL[i];
            outR[i] = inR[i];
        }
        resetFX();
        return;
    } else {
        fxResetted = false;
    }
    
    for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
        float mainInL = inL[i];
        float mainInR = inR[i];
        float filterOutL, filterOutR = 0;
        filterL->freq = 5000.0f * powf(lfoOne, 4);
        filterR->freq = 5000.0f * powf(lfoOne, 4);
        
        sp_moogladder_compute(sp, filterL, &mainInL, &filterOutL);
        sp_moogladder_compute(sp, filterR, &mainInR, &filterOutR);
        
        outL[i] = filterOutL;
        outR[i] = filterOutR;
        
    }
};
