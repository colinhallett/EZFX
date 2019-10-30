//
//  EZFilterKernelInit.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZFilterKernel.hpp"

EZFilterKernel::EZFilterKernel() {
    EZFilterKernel::reset();
}

void EZFilterKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    initSPAndSetValues();
};

void EZFilterKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        sp_phasor_destroy(&lfoPhasor);
        sp_moogladder_destroy(&filterL);
        sp_moogladder_destroy(&filterR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZFilterKernel::initSPAndSetValues() {
    
    sp_phasor_create(&lfoPhasor);
    sp_phasor_init(sp, lfoPhasor, 1);
       
    sp_moogladder_create(&filterL);
    sp_moogladder_init(sp, filterL);
    
    sp_moogladder_create(&filterR);
    sp_moogladder_init(sp, filterR);
}
   
