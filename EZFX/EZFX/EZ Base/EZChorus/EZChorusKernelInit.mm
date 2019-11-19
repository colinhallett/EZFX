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
        EZKernelBase::reset();
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
    modFreqHz = 1.0f;
    modDepthFraction = 0.0f;
    minDelayMs = kChorusMinDelayMs;
    maxDelayMs = kChorusMaxDelayMs;
    chorusModOscillator.init(sampleRate, modFreqHz);
    chorusModOscillator.waveTable.sinusoid();
    delayRangeMs = 0.5f * (maxDelayMs - minDelayMs);
    midDelayMs = 0.5f * (minDelayMs + maxDelayMs);
    chorusDelayLineL.init(sampleRate, maxDelayMs);
    chorusDelayLineR.init(sampleRate, maxDelayMs);
    chorusDelayLineL.setDelayMs(minDelayMs);
    chorusDelayLineR.setDelayMs(minDelayMs);
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
    chorusDelayLineL.setDelayMs(minFlangeMs);
    rightFlangeLine.setDelayMs(minFlangeMs);
    sp_phaser_create(&phaser);
    sp_phaser_init(sp, phaser);
    sp_crossfade_create(&crossfadeL);
    sp_crossfade_init(sp, crossfadeL);
    sp_crossfade_create(&crossfadeR);
    sp_crossfade_init(sp, crossfadeR);
    
    chorusDelayLineL.setFeedback(0.4);
    chorusDelayLineR.setFeedback(0.4);
    chorusModOscillator.setFrequency(0.93);
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
    
    *phaser->NotchFreq = 1.1;
    *phaser->Notch_width = 5000;
    *phaser->MaxNotch1Freq = 10000;//2000
    *phaser->MinNotch1Freq = 20;
    *phaser->invert = 1;
}
   

