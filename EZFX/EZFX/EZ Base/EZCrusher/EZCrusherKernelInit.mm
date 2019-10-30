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
        
        initSPAndSetValues();
        EZKernelBase::fxResetted = true;
    }
}

void EZCrusherKernel::initSPAndSetValues() {
    
}
   

