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
        sp_dist_destroy(&distL);
        sp_dist_destroy(&distR);
        sp_clip_destroy(&distClipL);
        sp_clip_destroy(&distClipR);
        sp_bitcrush_destroy(&bitcrushL);
        sp_bitcrush_destroy(&bitcrushR);
        sp_pdhalf_destroy(&phaseDist);
        sp_tabread_destroy(&tab);
        sp_ftbl_destroy(&fTable);
        sp_phasor_destroy(&phasor);
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
    //dist
    sp_dist_create(&distL);
    sp_dist_init(sp, distL);
    sp_dist_create(&distR);
    sp_dist_init(sp, distR);
    sp_clip_create(&distClipL);
    sp_clip_init(sp, distClipL);
    sp_clip_create(&distClipR);
    sp_clip_init(sp, distClipR);
    distClipL->lim = 5;
    distClipR->lim = 5;
    //bit crush
    sp_bitcrush_create(&bitcrushL);
    sp_bitcrush_init(sp, bitcrushL);
    sp_bitcrush_create(&bitcrushR);
    sp_bitcrush_init(sp, bitcrushR);
    //phase
    sp_pdhalf_create(&phaseDist);
    sp_ftbl_create(sp, &fTable, 2048);
    sp_gen_sine(sp, fTable);
    sp_tabread_create(&tab);
    sp_phasor_create(&phasor);
    
    sp_pdhalf_init(sp, phaseDist);
    sp_tabread_init(sp, tab, fTable, 1);
    sp_phasor_init(sp, phasor, 0);
    
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
   

