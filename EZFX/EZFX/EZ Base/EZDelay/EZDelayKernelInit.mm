//
//  EZDelayKernelInit.m
//  AudioKit
//
//  Created by Colin on 02/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZDelayKernel.hpp"

EZDelayKernel::EZDelayKernel() {
    EZDelayKernel::reset();
}

void EZDelayKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    initSPAndSetValues();
    
    sp_vdelay_create(&pingPongDelayL);
    sp_vdelay_init(sp, pingPongDelayL, 10.0f);
    pingPongDelayL->feedback = 0.8;
    
    sp_vdelay_create(&pinkPongDelayFillIn);
    sp_vdelay_init(sp, pinkPongDelayFillIn, 10.0f);
    pinkPongDelayFillIn->feedback = 0.8;
    
    sp_vdelay_create(&pingPongDelayR);
    sp_vdelay_init(sp, pingPongDelayR, 10.f);
    pingPongDelayR->feedback = 0.8;
    
    sp_vdelay_create(&simpleDelayL);
    sp_vdelay_init(sp, simpleDelayL, 10.f);
    simpleDelayL->feedback = 0.8;
    
    sp_vdelay_create(&simpleDelayR);
    sp_vdelay_init(sp, simpleDelayR, 10.f);
    simpleDelayR->feedback = 0.8;
    
    sp_vdelay_create(&reversedDelayL);
    sp_vdelay_init(sp, reversedDelayL, 10.f);
    reversedDelayL->feedback = 0.8;
    
    sp_vdelay_create(&reversedDelayR);
    sp_vdelay_init(sp, reversedDelayR, 10.f);
    reversedDelayR->feedback = 0.8;
    
    sp_reverse_create(&reverseL);
    sp_reverse_init(sp, reverseL, 1.0);
    sp_reverse_create(&reverseR);
    sp_reverse_init(sp, reverseR, 1.0);
    
    
};

void EZDelayKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        EZKernelBase::reset();
        sp_vdelay_reset(sp, pingPongDelayL);
        sp_vdelay_reset(sp, pinkPongDelayFillIn);
        sp_vdelay_reset(sp, pingPongDelayR);
        sp_vdelay_reset(sp, simpleDelayL);
        sp_vdelay_reset(sp, simpleDelayR);
        sp_vdelay_reset(sp, reversedDelayL);
        sp_vdelay_reset(sp, reversedDelayR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZDelayKernel::initSPAndSetValues() {
    
}
   
