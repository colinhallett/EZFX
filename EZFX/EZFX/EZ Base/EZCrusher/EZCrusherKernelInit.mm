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
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZCrusherKernel::initSPAndSetValues() {
    sp_ftbl_create(sp, &ft, 44100 );
       sp_ftbl_init(sp, ft, 44100 );
    
    
    sp_paulstretch_create(&timeStretch);
    sp_paulstretch_init(sp, timeStretch, ft, 1.5, 10);
    
    sp_tblrec_create(&tblrec);
    sp_tblrec_init(sp, tblrec, ft);
    
}
   

