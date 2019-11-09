//
//  EZCrusherProcess.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZCrusherKernel.hpp"

void EZCrusherKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
    float xPos = EZKernelBase::xValue - 0.5;
    float yPos = EZKernelBase::yValue - 0.5;
   // float dFromO = distanceFromOrigin(xPos, yPos);
    
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
        float trigger = 1;
       /* if (i == 0) {
            trigger = 0;
        }*/
        float tblrecOut = 0;
        SPFLOAT tick = (i == 0 ? 1 : 0);

        sp_tblrec_compute(sp, tblrec, &mainInL, &tick, &tblrecOut);
       
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float rampedXValue = 0;
        float rampedYValue = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
       
        float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue - 0.5;
        //float dFromO = distanceFromOrigin(xPos, yPos);//sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
        timeStretch->stretch = rampedXValue * 40;
        float paulstretchOut = 0.0f;
        sp_paulstretch_compute(sp, timeStretch, NULL, &paulstretchOut);
        
        float mainOutL = 0;
        float mainOutR = 0;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &paulstretchOut, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &paulstretchOut, &mainOutR);
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
