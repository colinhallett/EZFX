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
       
        sp_buthp_destroy(&inputHPFL);
        sp_buthp_destroy(&inputHPFR);
        sp_delay_destroy(&delayL);
        sp_delay_destroy(&delayR);
        sp_pshift_destroy(&pshiftL);
        sp_pshift_destroy(&pshiftR);
        sp_butlp_destroy(&filterL);
        sp_butlp_destroy(&filterR);
        sp_phaser_destroy(&phaser);
        widenRamper.reset();
        sp_port_destroy(&internalWidenRamper);
        sp_crossfade_destroy(&afterFXCrossfadeL);
        sp_crossfade_destroy(&afterFXCrossfadeR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZChorusKernel::initSPAndSetValues() {

    /// input create
    sp_buthp_create(&inputHPFL);
    sp_buthp_init(sp, inputHPFL);
    sp_buthp_create(&inputHPFR);
    sp_buthp_init(sp, inputHPFR);
    
    inputHPFL->freq = 100;
    inputHPFR->freq = 100;
    
    ///chorus
    /*
     #define kChorusMinModFreqHz          0.10f
     #define kChorusMaxModFreqHz         10.00f
     #define kChorusMinDepth              0.00f
     #define kChorusMaxDepth              1.00f
     #define kChorusMinFeedback           0.00f
     #define kChorusMaxFeedback           0.95f
     #define kChorusMinDryWetMix          0.00f
     #define kChorusMaxDryWetMix          1.00f
     */
    chorusModFreqHz = 1.0f;
    chorusModDepthFraction = 0.0f;
    minDelayMs = kChorusMinDelayMs;
    maxDelayMs = kChorusMaxDelayMs;
    chorusModOscillator.init(sampleRate, chorusModFreqHz);
    chorusModOscillator.waveTable.sinusoid();
    delayRangeMs = 0.5f * (maxDelayMs - minDelayMs);
    midDelayMs = 0.5f * (minDelayMs + maxDelayMs);
    chorusDelayLineL.init(sampleRate, maxDelayMs);
    chorusDelayLineR.init(sampleRate, maxDelayMs);
    chorusDelayLineL.setDelayMs(minDelayMs);
    chorusDelayLineR.setDelayMs(minDelayMs);
    
    chorusDelayLineL.setFeedback(0.4);
    chorusDelayLineR.setFeedback(0.4);
    chorusModOscillator.setFrequency(0.93);
    chorusDryWetMix = 1.0;
    //chorusModDepthFraction = 0.05;
    
    ///flanger
    /*
     #define kFlangerMinModFreqHz         0.10f
     #define kFlangerMaxModFreqHz        10.00f
     #define kFlangerMinDepth             0.00f
     #define kFlangerMaxDepth             1.00f
     #define kFlangerMinFeedback         -0.95f
     #define kFlangerMaxFeedback          0.95f
     #define kFlangerMinDryWetMix         0.00f
     #define kFlangerMaxDryWetMix         1.00f
     */
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
    leftFlangeLine.setDelayMs(minFlangeMs);
    rightFlangeLine.setDelayMs(minFlangeMs);
    
    leftFlangeLine.setFeedback(0);
    rightFlangeLine.setFeedback(0);
    flangeOscillator.setFrequency(0.5);
    flangeDryWetMix = 1.0;
    flangeModDepthFraction = 0.5;
    
    ///phaser
    sp_phaser_create(&phaser);
    sp_phaser_init(sp, phaser);
    
    *phaser->NotchFreq = 2;
    *phaser->Notch_width = 5000;
   // *phaser->MaxNotch1Freq = 2000;//2000
    *phaser->MinNotch1Freq = 20;
    //*phaser->invert = 1;
    *phaser->feedback_gain = 0.75;
    *phaser->depth = 1.0;
    
    ///output stuff
    
    sp_delay_create(&delayL);
    sp_delay_init(sp, delayL, 0.03);
    sp_delay_create(&delayR);
    sp_delay_init(sp, delayR, 0.04);
    sp_pshift_create(&pshiftL);
    sp_pshift_init(sp, pshiftL);
    sp_pshift_create(&pshiftR);
    sp_pshift_init(sp, pshiftR);
    sp_butlp_create(&filterL);
    sp_butlp_init(sp, filterL);
    sp_butlp_create(&filterR);
    sp_butlp_init(sp, filterR);
    
    delayL->feedback = 0;
    delayR->feedback = 0;
    float defaultWindowSize = 1024;
    float defaultCrossfade = 512;
    float pshiftAmountL = -0.15;
    float pshiftAmountR = -0.25;
    *pshiftL->shift = pshiftAmountL;
    *pshiftL->window = defaultWindowSize;
    *pshiftL->xfade = defaultCrossfade;
    *pshiftR->shift = pshiftAmountR;
    *pshiftR->window = defaultWindowSize;
    *pshiftR->xfade = defaultCrossfade;
    filterL->freq = 8000.0;
    filterR->freq = 8000.0;
    
    widenRamper.init();
    sp_port_create(&internalWidenRamper);
    sp_port_init(sp, internalWidenRamper, 0.01);
    sp_crossfade_create(&afterFXCrossfadeL);
    sp_crossfade_init(sp, afterFXCrossfadeL);
    sp_crossfade_create(&afterFXCrossfadeR);
    sp_crossfade_init(sp, afterFXCrossfadeR);
}
   

