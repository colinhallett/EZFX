//
//  EZSpacerKernel.cpp
//  AudioKit
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZSpacerKernel.hpp"
#include <iostream>

EZSpacerKernel::EZSpacerKernel() {
    EZSpacerKernel::reset();
}

void EZSpacerKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    
    sp_revsc_create(&reverb);
    sp_crossfade_create(&reverbCrossfadeL);
    sp_crossfade_create(&reverbCrossfadeR);
    sp_revsc_init(getSpData(), reverb);
    sp_crossfade_init(getSpData(), reverbCrossfadeL);
    sp_crossfade_init(getSpData(), reverbCrossfadeR);
    
    reverb->feedback = reverbTime;
    reverb->lpfreq = 15000;
    reverbCrossfadeL->pos = reverbStrength;
    reverbCrossfadeR->pos = reverbStrength;
};

void EZSpacerKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        sp_revsc_destroy(&reverb);
        sp_crossfade_destroy(&reverbCrossfadeL);
        sp_crossfade_destroy(&reverbCrossfadeR);
        sp_revsc_create(&reverb);
        sp_crossfade_create(&reverbCrossfadeL);
        sp_crossfade_create(&reverbCrossfadeR);
        sp_revsc_init(getSpData(), reverb);
        sp_crossfade_init(getSpData(), reverbCrossfadeL);
        sp_crossfade_init(getSpData(), reverbCrossfadeR);
        EZKernelBase::fxResetted = true;
    }
}
   
void EZSpacerKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
   
    reverb->feedback = EZKernelBase::xValue;
    reverbCrossfadeL->pos = EZKernelBase::yValue;
    reverbCrossfadeR->pos = EZKernelBase::yValue;
    
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
        if (i == 0) {
          //  std::cout << inL[i] << "\n";
        }
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        if (EZKernelBase::isActive == 0) {
            mainInL = 0;
            mainInR = 0;
        }
        float reverbOutL = 0.0f;
        float reverbOutR = 0.0f;
        sp_revsc_compute(sp, reverb, &mainInL, &mainInR, &reverbOutL, &reverbOutR);
        
        float reverbMixL = 0.0f;
        float reverbMixR = 0.0f;
        sp_crossfade_compute(sp, reverbCrossfadeL, &mainInL, &reverbOutL, &reverbMixL);
        sp_crossfade_compute(sp, reverbCrossfadeR, &mainInR, &reverbOutR, &reverbMixR);
       
        outL[i] = reverbMixL;//reverbOutL * 0.5;
        outR[i] = reverbMixR;//reverbOutR * 0.5;
    }
};
