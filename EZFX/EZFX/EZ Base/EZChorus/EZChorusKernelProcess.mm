//
//  EZChorusKernelProcess.m
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZChorusKernel.hpp"

void EZChorusKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
    float xPos = EZKernelBase::xValue - 0.5;
    float yPos = EZKernelBase::yValue - 0.5;
    float dFromO = distanceFromOrigin(xPos, yPos);//sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
    
    reverb->feedback = dFromO;
    reverbCrossfadeL->pos = 1 - dFromO;
    reverbCrossfadeR->pos = dFromO;//EZKernelBase::yValue;
    modOscillator.setFrequency(dFromO * 20.0f);
    flangeOscillator.setFrequency((1 - EZKernelBase::yValue) * 10.0f);
    flangeModDepthFraction = dFromO;
    delayL->feedback = 0.95 * EZKernelBase::yValue;
    delayR->feedback = 0.95 * EZKernelBase::yValue;
    filterL->freq = 15000.0f * dFromO + 5000;
    filterR->freq = 15000.0f * dFromO + 5000;
    //crossfadeL->pos = (1 - EZKernelBase::xValue);
    //crossfadeR->pos = EZKernelBase::xValue;
    if (EZKernelBase::isActive <= 0.5) {
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
           // std::cout << distanceFromOrigin << "\n";
        }
        
        float mainInL = inL[i];
        float mainInR = inR[i];
        if (EZKernelBase::isActive <= 0.5) {
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
       
        float chorusOneInL = mainInL;
        float chorusOneInR = mainInR;
        float chorusOneOutL = 0.0f;
        float chorusOneOutR = 0.0f;
        
        float modLeft, modRight;
        modOscillator.getSamples(&modLeft, &modRight);
        
        float leftDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modRight;
        leftDelayLine.setDelayMs(leftDelayMs);
        rightDelayLine.setDelayMs(rightDelayMs);
        chorusOneOutL = leftDelayLine.push(chorusOneInL);
        chorusOneOutR = rightDelayLine.push(chorusOneInR);
        float chorusOneDelayL = 0.0f;
        float chorusOneDelayR = 0.0f;
        sp_delay_compute(sp, delayL, &chorusOneOutL, &chorusOneDelayL);
        sp_delay_compute(sp, delayR, &chorusOneOutR, &chorusOneDelayR);
        float chorusOnePShiftL = 0.0f;
        float chorusOnePShiftR = 0.0f;
        sp_pshift_compute(sp, pshiftL, &chorusOneDelayL, &chorusOnePShiftL);
        sp_pshift_compute(sp, pshiftR, &chorusOneDelayR, &chorusOnePShiftR);
        float chorusOneFilterL = 0.0f;
        float chorusOneFilterR = 0.0f;
        sp_butlp_compute(sp, filterL, &chorusOnePShiftL, &chorusOneFilterL);
        sp_butlp_compute(sp, filterR, &chorusOnePShiftR, &chorusOneFilterR);
        float chorusFlangeOutL = 0.0f;
        float chorusFlangeOutR = 0.0f;
        float flangeL, flangeR;
        flangeOscillator.getSamples(&flangeL, &flangeR);
        
        float leftFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeL;
        float rightFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeR;
        
        leftFlangeLine.setDelayMs(leftFlangeMs);
        rightFlangeLine.setDelayMs(rightFlangeMs);
        chorusFlangeOutL = leftFlangeLine.push(chorusOneFilterL);
        chorusFlangeOutR = rightFlangeLine.push(chorusOneFilterR);

        float chorusOneCrossfadeL = 0.0f;
        float chorusOneCrossfadeR = 0.0f;
        sp_crossfade_compute(sp, crossfadeL, &mainInL, &chorusFlangeOutL, &chorusOneCrossfadeL);
        sp_crossfade_compute(sp, crossfadeR, &mainInR, &chorusFlangeOutR, &chorusOneCrossfadeR);
        
        outL[i] = chorusOneCrossfadeL;
        outR[i] = chorusOneCrossfadeR;
    }
};
