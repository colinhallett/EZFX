//
//  EZSpacerKernel.cpp
//  AudioKit
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZSpacerKernel.hpp"

void EZSpacerKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    
    sp_revsc_init(getSpData(), reverb);
    sp_crossfade_init(getSpData(), reverbCrossfadeL);
    sp_crossfade_init(getSpData(), reverbCrossfadeR);
    
    reverb->feedback = reverbTime;
    reverb->lpfreq = 15000;
    reverbCrossfadeL->pos = reverbStrength;
    reverbCrossfadeR->pos = reverbStrength;
};
   
void EZSpacerKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
   
    reverb->feedback = EZKernelBase::xValue;
    reverbCrossfadeL->pos = EZKernelBase::yValue;
    reverbCrossfadeR->pos = EZKernelBase::yValue;
    
    for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
        float reverbOutL = 0.0f;
        float reverbOutR = 0.0f;
        sp_revsc_compute(sp, reverb, outL, outR, &reverbOutL, &reverbOutR);
        
        float reverbMixL = 0.0f;
        float reverbMixR = 0.0f;
        sp_crossfade_compute(sp, reverbCrossfadeL, outL, &reverbOutL, &reverbMixL);
        sp_crossfade_compute(sp, reverbCrossfadeR, outR, &reverbOutR, &reverbMixR);
        outL[i] = reverbMixL;
        outR[i] = reverbMixR;
    }
};
