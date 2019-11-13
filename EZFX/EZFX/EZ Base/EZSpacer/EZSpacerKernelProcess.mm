//
//  EZSpacerKernelProcess.m
//  AudioKit
//
//  Created by Colin on 20/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZSpacerKernel.hpp"

void EZSpacerKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
    lfoPhasor->freq = 0.02;//xStrength * 10.0f;
    
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
        // outL[i] = outR[i] = 0.f;
        //int frameOffset = int(i + bufferOffset);
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float outputLevel = EZKernelBase::outputLevel;
        float rampedXValue = 0;
        float rampedYValue = 0;
        float rampedOutputLevel = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        
        float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue  - 0.5;
       // float dFromO = distanceFromOrigin(xPos, yPos);
        float yValueExp = powf(2, (powf(rampedYValue, 5))) - 1;
        float xStrength = (2 * (xPos > 0 ? xPos : 0)) * (yPos > 0 ? 1 : 0);
        *reverb->rt60_low = yValueExp * 2000.0f + 1;
        *reverb->rt60_mid = yValueExp * 2000.0f + 1;
        *reverb->hf_damping = 20000.0f * rampedXValue;
        *reverb->in_delay = rampedXValue * 1000;
        *reverb->eq1_freq = 315;
        *reverb->eq1_level = xStrength;
        //*reverb->mix = (xPos * xPos) * 4;
        
        sp_phasor_compute(getSpData(), lfoPhasor, nil, &lfoOne);
        lfoOne = sin(lfoOne * M_PI * 2.f);
        

        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float reverbOutL = 0;
        float reverbOutR = 0;
        
        *reverb->eq1_freq = 10000 - (9000 * xStrength * powf(lfoOne, 4));
        sp_zitarev_compute(sp, reverb, &mainInL, &mainInR, &reverbOutL, &reverbOutR);
    
        reverbOutL *= rampedOutputLevel;
        reverbOutR *= rampedOutputLevel;
        
        float mainOutL = 0;
        float mainOutR = 0;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &reverbOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &reverbOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
