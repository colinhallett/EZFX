//
//  EZDelayKernelProcess.m
//  AudioKit
//
//  Created by Colin on 02/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZDelayKernel.hpp"

void EZDelayKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
    float xPos = EZKernelBase::xValue - 0.5;
    float yPos = EZKernelBase::yValue - 0.5;
    float dFromO = distanceFromOrigin(xPos, yPos);
    
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
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float rampedXValue = 0;
        float rampedYValue = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        
        float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue - 0.5;
        float dFromO = distanceFromOrigin(xPos, yPos);
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float delayFeedback = 0.8;
        float delayTime = rampedYValue * 10;
        float vDelayOutL = 0;
        float vDelayOutR = 0;
        vDelayL->feedback = delayFeedback;
        vDelayL->del = delayTime;
        sp_vdelay_compute(sp, vDelayL, &mainInL, &vDelayOutL);
        vDelayR->feedback = delayFeedback;
        vDelayR->del = delayTime;
        sp_vdelay_compute(sp, vDelayR, &mainInR, &vDelayOutR);
        
        float mainOutL = 0;
        float mainOutR = 0;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &vDelayOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &vDelayOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        float rmsOutL = 0;
        float rmsOutR = 0;
        sp_rms_compute(sp, leftRMS, &mainOutL, &rmsOutL);
        sp_rms_compute(sp, rightRMS, &mainOutR, &rmsOutR);
        leftAmplitude = rmsOutL;
        rightAmplitude = rmsOutR;
    }
};
