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
    
    sp_vdelay_create(&vDelayL);
    sp_vdelay_init(sp, vDelayL, 10.0f);
    vDelayL->feedback = 0.8;
    
    sp_vdelay_create(&vDelayR);
    sp_vdelay_init(sp, vDelayR, 10.0f);
    vDelayR->feedback = 0.8;
    
    sp_vdelay_create(&vDelayRR);
    sp_vdelay_init(sp, vDelayRR, 10.f);
    vDelayRR->feedback = 0.8;
    
    sp_vdelay_create(&vDelayFillIn);
    sp_vdelay_init(sp, vDelayFillIn, 10.f);
    vDelayFillIn->feedback = 0.8;
};

void EZDelayKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        EZKernelBase::reset();
        sp_vdelay_reset(sp, vDelayL);
        sp_vdelay_reset(sp, vDelayR);
        sp_vdelay_reset(sp, vDelayRR);
        sp_vdelay_reset(sp, vDelayFillIn);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZDelayKernel::initSPAndSetValues() {
    
}
   
