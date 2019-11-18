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
        
        
        float delayFeedback = rampedYValue - 0.0001;
        float delayTime = expXVal * 5 + 0.0001;
        //simple delay
        
        float simpleDelayOutL, simpleDelayOutR;
        
        simpleDelayL->del = delayTime;
        simpleDelayR->del = delayTime;
        
        simpleDelayL->feedback = delayFeedback;
        simpleDelayR->feedback = delayFeedback;
        
        sp_vdelay_compute(sp, simpleDelayL, &inputSaturatorOutL, &simpleDelayOutL);
        sp_vdelay_compute(sp, simpleDelayR, &inputSaturatorOutR, &simpleDelayOutR);
        
        //ping pong delay
        
        float pingPongOutL = 0.f;
        float pingPongFillIn = 0.f;
        float pingPongOutR = 0.f;
        
        pingPongDelayL->del = pinkPongDelayFillIn->del = delayTime * 2.f;
        
        pingPongDelayR->del = delayTime;
        
        pingPongDelayL->feedback = pinkPongDelayFillIn->feedback = delayFeedback;
        
        pingPongDelayR->feedback =  0;
        
        sp_vdelay_compute(sp, pingPongDelayL, &inputSaturatorOutL, &pingPongOutL);
        
        sp_vdelay_compute(sp, pinkPongDelayFillIn, &inputSaturatorOutR, &pingPongFillIn);
        
        sp_vdelay_compute(sp, pingPongDelayR, &pingPongFillIn, &pingPongOutR);
        
        //reverse delay:
        float reverseDelayOutL, reverseDelayOutR;
        
        reversedDelayL->del = delayTime;
        reversedDelayR->del = delayTime;
        
        reversedDelayL->feedback = delayFeedback;
        reversedDelayR->feedback = delayFeedback;
        
        sp_vdelay_compute(sp, reversedDelayL, &inputSaturatorOutL, &reverseDelayOutL);
        sp_vdelay_compute(sp, reversedDelayR, &inputSaturatorOutR, &reverseDelayOutR);
        
        float reverseOutL, reverseOutR;
        
        reverseL->delay = delayTime;
        reverseR->delay = delayTime;
        
        sp_reverse_compute(sp, reverseL, &reverseDelayOutL, &reverseOutL);
        sp_reverse_compute(sp, reverseR, &reverseDelayOutR, &reverseOutR);
        
        //switch
        float mainDelayOutL, mainDelayOutR;
        
        switch (delayType) {
            case 0:
                mainDelayOutL = simpleDelayOutL;
                mainDelayOutR = simpleDelayOutR;
                break;
            case 1:
                mainDelayOutL = pingPongOutL;
                mainDelayOutR = pingPongOutR;
                break;
            case 2:
                mainDelayOutL = reverseOutL;
                mainDelayOutR = reverseOutR;
                break;
            default:
                mainDelayOutL = 0;
                mainDelayOutR = 0;
        }
        
        mainDelayOutL *= rampedOutputLevel;
        mainDelayOutR *= rampedOutputLevel;
        
        float mainOutL = 0;
        float mainOutR = 0;
        
        float rampedMix = 0;
        sp_port_compute(sp, mixInternalRamper, &mix, &rampedMix);
        mixL->pos = rampedMix;
        mixR->pos = rampedMix;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &mainDelayOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &mainDelayOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
