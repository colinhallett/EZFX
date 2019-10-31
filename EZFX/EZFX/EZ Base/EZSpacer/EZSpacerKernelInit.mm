//
//  EZSpacerKernel.cpp
//  AudioKit
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZSpacerKernel.hpp"

EZSpacerKernel::EZSpacerKernel() {
    EZSpacerKernel::reset();
}

void EZSpacerKernel::init(int channelCount, double sampleRate) {
    EZKernelBase::init(channelCount, sampleRate);
    initSPAndSetValues();
    
};

void EZSpacerKernel::resetFX() {
    if (!EZKernelBase::fxResetted) {
        EZKernelBase::resetCrossfade();
        sp_zitarev_destroy(&reverb);
        
        sp_phasor_destroy(&lfoPhasor);
        
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZSpacerKernel::initSPAndSetValues() {
    
    sp_zitarev_create(&reverb);
    sp_zitarev_init(sp, reverb);
    *reverb->level = 0.0;
    *reverb->mix = 1.0;
    *reverb->rt60_low = 10.0f;
    *reverb->rt60_mid = 10.0f;
    *reverb->hf_damping = 10000.0f;
    *reverb->in_delay = 0;
    
    sp_phasor_create(&lfoPhasor);
    sp_phasor_init(sp, lfoPhasor, 1);
    
    
}
   

