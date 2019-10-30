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
    float xPos = EZKernelBase::xValue - 0.5;
    float yPos = EZKernelBase::yValue - 0.5;
    float dFromO = distanceFromOrigin(xPos, yPos);
    
    *reverb->mix = dFromO;
    *reverb->rt60_low = dFromO * 50.0f;
    *reverb->rt60_mid = dFromO * 50.0f;
    *reverb->hf_damping = dFromO * 10000.0f;
    *reverb->in_delay = dFromO;
    
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
        
        sp_phasor_compute(getSpData(), lfoPhasor, nil, &lfoOne);
        lfoOne = sin(lfoOne * M_PI * 2.f);
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        
        float reverbOutL = 0;
        float reverbOutR = 0;
       
        sp_zitarev_compute(sp, reverb, &mainInL, &mainInR, &reverbOutL, &reverbOutR);
        
        outL[i] = reverbOutL;
        outR[i] = reverbOutR;
        
    }
};
