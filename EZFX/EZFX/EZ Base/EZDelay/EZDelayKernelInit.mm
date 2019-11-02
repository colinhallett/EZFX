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
    sp_vdelay_init(sp, vDelayL, 10.f);
    vDelayL->feedback = 0.8;
    
    sp_vdelay_create(&vDelayR);
    sp_vdelay_init(sp, vDelayR, 10.f);
    vDelayR->feedback = 0.8;
};

void EZDelayKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        EZKernelBase::reset();
        sp_vdelay_reset(sp, vDelayL);
        sp_vdelay_reset(sp, vDelayR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZDelayKernel::initSPAndSetValues() {
    
}
   
