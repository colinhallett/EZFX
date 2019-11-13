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
        float rampedOutputLevel = 0;
        float rampedInputLevel = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        sp_port_compute(sp, internalInputLevelRamper, &inputLevel, &rampedInputLevel);
        float expXVal = expValue(rampedXValue, 2);
        //float yPos = rampedYValue - 0.5;
       // float dFromO = distanceFromOrigin(xPos, yPos);
        
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float inputLevelOutL = mainInL * rampedInputLevel;
        float inputLevelOutR = mainInR * rampedInputLevel;
        
        float inputSaturatorOutL, inputSaturatorOutR;
        sp_saturator_compute(sp, inputSaturatorL, &inputLevelOutL, &inputSaturatorOutL);
        sp_saturator_compute(sp, inputSaturatorR, &inputLevelOutR, &inputSaturatorOutR);
        
        
        float delayFeedback = rampedYValue;
        float delayTime = expXVal * 5;
        
        float delayOutL = 0.f;
        float delayOutR = 0.f;
        float delayOutRR = 0.f;
        float delayFillInOut = 0.f;
        
        vDelayL->del = vDelayR->del = delayTime * 2.f;
        
        vDelayRR->del = vDelayFillIn->del = delayTime;
        
        vDelayL->feedback = vDelayR->feedback = delayFeedback;
        
        vDelayRR->feedback = vDelayFillIn->feedback = 0;
        
        sp_vdelay_compute(sp, vDelayL, &inputSaturatorOutL, &delayOutL);
        
        sp_vdelay_compute(sp, vDelayR, &inputSaturatorOutR, &delayOutR);
        
   //     sp_vdelay_compute(sp, vDelayFillIn, &mainInR, &delayFillInOut);
        
        sp_vdelay_compute(sp, vDelayRR, &delayOutR, &delayOutRR);
        
       // delayOutRR += delayFillInOut;
        
        delayOutL *= rampedOutputLevel;
        delayOutRR *= rampedOutputLevel;
        
        float mainOutL = 0;
        float mainOutR = 0;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &delayOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &delayOutRR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
