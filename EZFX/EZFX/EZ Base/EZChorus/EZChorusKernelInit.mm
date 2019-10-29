//
//  EZChorusKernelInit.m
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZChorusKernel.hpp"

EZChorusKernel::EZChorusKernel() {
    EZChorusKernel::reset();
}

void EZChorusKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    initSPAndSetValues();
};

void EZChorusKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        sp_revsc_destroy(&reverb);
        sp_crossfade_destroy(&reverbCrossfadeL);
        sp_crossfade_destroy(&reverbCrossfadeR);
        sp_delay_destroy(&delayL);
        sp_delay_destroy(&delayR);
        sp_pshift_destroy(&pshiftL);
        sp_pshift_destroy(&pshiftR);
        sp_butlp_destroy(&filterL);
        sp_butlp_destroy(&filterR);
        sp_phaser_destroy(&phaser);
        sp_crossfade_destroy(&crossfadeL);
        sp_crossfade_destroy(&crossfadeR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZChorusKernel::initSPAndSetValues() {
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
    
    modFreqHz = 1.0f;
    modDepthFraction = 0.0f;
    minDelayMs = kChorusMinDelayMs;
    maxDelayMs = kChorusMaxDelayMs;
    modOscillator.init(sampleRate, modFreqHz);
    modOscillator.waveTable.sinusoid();
    delayRangeMs = 0.5f * (maxDelayMs - minDelayMs);
    midDelayMs = 0.5f * (minDelayMs + maxDelayMs);
    leftDelayLine.init(sampleRate, maxDelayMs);
    rightDelayLine.init(sampleRate, maxDelayMs);
    leftDelayLine.setDelayMs(minDelayMs);
    rightDelayLine.setDelayMs(minDelayMs);
    sp_delay_create(&delayL);
    sp_delay_init(sp, delayL, 0.01);
    sp_delay_create(&delayR);
    sp_delay_init(sp, delayR, 0.02);
    sp_pshift_create(&pshiftL);
    sp_pshift_init(sp, pshiftL);
    sp_pshift_create(&pshiftR);
    sp_pshift_init(sp, pshiftR);
    sp_butlp_create(&filterL);
    sp_butlp_init(sp, filterL);
    sp_butlp_create(&filterR);
    sp_butlp_init(sp, filterR);
    flangeModFreqHz = 1.0f;
    flangeModDepthFraction = 0.0f;
    minFlangeMs = kFlangerMinDelayMs;
    maxFlangeMs = kFlangerMaxDelayMs;
    flangeOscillator.init(sampleRate, flangeModFreqHz);
    flangeOscillator.waveTable.triangle();
    flangeRangeMs = 0.5f * (maxFlangeMs - minFlangeMs);
    midFlangeMs = 0.5f * (minFlangeMs + maxFlangeMs);
    leftFlangeLine.init(sampleRate, maxFlangeMs);
    rightFlangeLine.init(sampleRate, maxFlangeMs);
    leftDelayLine.setDelayMs(minFlangeMs);
    rightFlangeLine.setDelayMs(minFlangeMs);
    sp_phaser_create(&phaser);
    sp_phaser_init(sp, phaser);
    sp_crossfade_create(&crossfadeL);
    sp_crossfade_init(sp, crossfadeL);
    sp_crossfade_create(&crossfadeR);
    sp_crossfade_init(sp, crossfadeR);
    
    leftDelayLine.setFeedback(0.4);
    rightDelayLine.setFeedback(0.4);
    modOscillator.setFrequency(0.93);
    dryWetMix = 1.0;
    modDepthFraction = 0.05;
    delayL->feedback = 0.01;
    delayL->time = 0.01;
    delayR->feedback = 0.01;
    delayR->time = 0.02;
    float defaultWindowSize = 1024;
    float defaultCrossfade = 512;
    float pshiftAmountL = -0.1;
    float pshiftAmountR = -0.2;
    *pshiftL->shift = pshiftAmountL;
    *pshiftL->window = defaultWindowSize;
    *pshiftL->xfade = defaultCrossfade;
    *pshiftR->shift = pshiftAmountR;
    *pshiftR->window = defaultWindowSize;
    *pshiftR->xfade = defaultCrossfade;
    filterL->freq = 6000.0f;
    filterR->freq = 6000.0f;
    leftFlangeLine.setFeedback(0.1);
    rightFlangeLine.setFeedback(0.1);
    flangeOscillator.setFrequency(0.5);
    flangeDryWetMix = 1.0;
    flangeModDepthFraction = 0.2;
    crossfadeL->pos = 0.5;
    crossfadeR->pos = 0.5;
}
   

