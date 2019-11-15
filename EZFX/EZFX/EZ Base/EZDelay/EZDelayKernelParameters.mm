//
//  EZDelayKernelParameters.m
//  AudioKit
//
//  Created by Colin on 14/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZDelayKernel.hpp"

void EZDelayKernel::setParameter(AUParameterAddress address, float value) {
    
    switch (address) {
        case delayTypeAddress:
            delayType = int(value);
            break;
        default:
            EZKernelBase::setParameter(address, value);
    }
}

// Uses the ParameterAddress as a key
float EZDelayKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case delayTypeAddress:
            return delayType;
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZDelayKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case delayTypeAddress:
            delayType = int(value);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
    }
}

void EZDelayKernel::getAndSteps() {
    EZKernelBase::standardEZFXGetAndSteps();
}
