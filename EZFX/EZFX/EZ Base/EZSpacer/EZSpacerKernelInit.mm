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
        
        EZKernelBase::fxResetted = true;
    }
}

void EZSpacerKernel::initSPAndSetValues() {
    
}
   

