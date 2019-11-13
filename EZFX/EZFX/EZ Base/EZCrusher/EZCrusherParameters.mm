//
//  EZCrusherParameters.m
//  AudioKit
//
//  Created by Colin on 11/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZCrusherKernel.hpp"

void EZCrusherKernel::setParameter(AUParameterAddress address, float value) {
    switch (address) {
        case noiseLevelAddress:
            noiseLevelRamper.setUIValue(clamp(value, 0.0f, 1.0f));
            break;
        default:
            EZKernelBase::setParameter(address, value);
    }
}

// Uses the ParameterAddress as a key
float EZCrusherKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case noiseLevelAddress:
            return noiseLevelRamper.getUIValue();
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZCrusherKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)  {
    switch (address) {
        case noiseLevelAddress:
            noiseLevelRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
    }
}

void EZCrusherKernel::getAndSteps() {
    noiseLevel = noiseLevelRamper.getAndStep();
    EZKernelBase::standardEZFXGetAndSteps();
}
