//
//  EZSpacerKernelParameters.m
//  AudioKit
//
//  Created by Colin on 15/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZSpacerKernel.hpp"

// Uses the ParameterAddress as a key
void EZSpacerKernel::setParameter(AUParameterAddress address, float value) {
    switch (address) {
        case predelayAddress:
            predelayRamper.setUIValue(clamp(value, 0.0f, 1000.0f));
            break;
        default:
            EZKernelBase::setParameter(address, value);
            break;
    }
}
// Uses the ParameterAddress as a key
float EZSpacerKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case predelayAddress:
            return predelayRamper.getUIValue();
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZSpacerKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case predelayAddress:
            predelayRamper.startRamp(clamp(value, 0.0f, 1000.0f), duration);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
    }
}

void EZSpacerKernel::getAndSteps() {
    predelay = predelayRamper.getAndStep();
    EZKernelBase::standardEZFXGetAndSteps();
}
