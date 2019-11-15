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
        sp_moogladder_destroy(&lpfL);
        sp_moogladder_destroy(&lpfR);
        sp_reson_destroy(&bwL);
        sp_reson_destroy(&bwR);
        sp_buthp_destroy(&hpfL);
        sp_buthp_destroy(&hpfR);
        sp_streson_destroy(&stringL);
        sp_streson_destroy(&stringR);
        sp_wpkorg35_destroy(&lpf35L);
        sp_wpkorg35_destroy(&lpf35R);
        sp_port_destroy(&lfoModInternalRamper);
        sp_port_destroy(&lfoRateInternalRamper);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZFilterKernel::initSPAndSetValues() {
    sp_phasor_create(&lfoPhasor);
    sp_phasor_init(sp, lfoPhasor, 1);
       
    sp_moogladder_create(&lpfL);
    sp_moogladder_init(sp, lpfL);
    lpfL->res = 0;
    
    sp_moogladder_create(&lpfR);
    sp_moogladder_init(sp, lpfR);
    lpfR->res = 0;
    
    sp_reson_create(&bwL);
    sp_reson_init(sp, bwL);
    bwL->bw = 100;
    sp_reson_create(&bwR);
    sp_reson_init(sp, bwR);
    bwR->bw = 100;
    
    sp_buthp_create(&hpfL);
    sp_buthp_init(sp, hpfL);
    sp_buthp_create(&hpfR);
    sp_buthp_init(sp, hpfR);
    
    sp_streson_create(&stringL);
    sp_streson_init(sp, stringL);
    sp_streson_create(&stringR);
    sp_streson_init(sp, stringR);
    
    sp_wpkorg35_create(&lpf35L);
    sp_wpkorg35_init(sp, lpf35L);
    sp_wpkorg35_create(&lpf35R);
    sp_wpkorg35_init(sp, lpf35R);
    
    sp_port_create(&lfoModInternalRamper);
    sp_port_init(sp, lfoModInternalRamper, 0.01);
    sp_port_create(&lfoRateInternalRamper);
    sp_port_init(sp, lfoRateInternalRamper, 0.01);
}
   
