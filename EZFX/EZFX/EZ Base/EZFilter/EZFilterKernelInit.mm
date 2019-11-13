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
        EZKernelBase::reset();
        sp_phasor_destroy(&lfoPhasor);
        sp_moogladder_destroy(&filterL);
        sp_moogladder_destroy(&filterR);
        sp_port_destroy(&lfoModInternalRamper);
        sp_port_destroy(&lfoRateInternalRamper);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZFilterKernel::initSPAndSetValues() {
    
    sp_phasor_create(&lfoPhasor);
    sp_phasor_init(sp, lfoPhasor, 1);
       
    sp_moogladder_create(&filterL);
    sp_moogladder_init(sp, filterL);
    filterL->res = 0;
    
    sp_moogladder_create(&filterR);
    sp_moogladder_init(sp, filterR);
    filterR->res = 0;
    
    sp_port_create(&lfoModInternalRamper);
    sp_port_init(sp, lfoModInternalRamper, 0.01);
    sp_port_create(&lfoRateInternalRamper);
    sp_port_init(sp, lfoRateInternalRamper, 0.01);
}
   
