//
//  EZCrusherKernelInit.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZCrusherKernel.hpp"

EZCrusherKernel::EZCrusherKernel() {
    EZCrusherKernel::reset();
}

void EZCrusherKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    initSPAndSetValues();
};

void EZCrusherKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        EZKernelBase::reset();
        sp_buthp_destroy(&outputHpfL);
        sp_buthp_destroy(&outputHpfR);
        sp_saturator_destroy(&saturatorL);
        sp_saturator_destroy(&saturatorR);
        sp_port_destroy(&noiseLevelInternalRamper);
        sp_pinknoise_destroy(&pinkNoise);
        sp_buthp_destroy(&noiseHpf);
        sp_jitter_destroy(&randomiser);
        sp_compressor_destroy(&compL);
        sp_compressor_destroy(&compR);
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZCrusherKernel::initSPAndSetValues() {
    sp_port_create(&noiseLevelInternalRamper);
    sp_port_init(sp, noiseLevelInternalRamper, 0.01);
    //dist hpf
    sp_buthp_create(&outputHpfL);
    sp_buthp_init(sp, outputHpfL);
    sp_buthp_create(&outputHpfR);
    sp_buthp_init(sp, outputHpfR);
    outputHpfL->freq = 50;
    outputHpfR->freq = 50;
    // saturator
    sp_saturator_create(&saturatorL);
    sp_saturator_init(sp, saturatorL);
    sp_saturator_create(&saturatorR);
    sp_saturator_init(sp, saturatorR);
    //noise
    sp_pinknoise_create(&pinkNoise);
    sp_pinknoise_init(sp, pinkNoise);
    sp_buthp_create(&noiseHpf);
    sp_buthp_init(sp, noiseHpf);
    noiseHpf->freq = 3000;
    sp_jitter_create(&randomiser);
    sp_jitter_init(sp, randomiser);
    randomiser->amp = 0.8;
    
    randomiser->cpsMin = 20;
    randomiser->cpsMax = 30;
    
    sp_compressor_create(&compL);
    sp_compressor_init(sp, compL);
    sp_compressor_create(&compR);
    sp_compressor_init(sp, compR);
    
    *compL->ratio = 4.0f;
    *compL->atk = 0.1f;
    *compL->rel = 0.3f;
    *compL->thresh = -15.f;
    *compR->ratio = 4.0f;
    *compR->atk = 0.1f;
    *compR->rel = 0.3f;
    *compR->thresh = -15.f;
}
   

