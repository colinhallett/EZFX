//
//  EZFilterKernelParameters.m
//  AudioKit
//
//  Created by Colin on 09/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZFilterKernel.hpp"

void EZFilterKernel::setParameter(AUParameterAddress address, float value) {
    switch (address) {
        case lfoModAddress:
            lfoModRamper.setUIValue(clamp(value, 0.0f, 1.0f));
            break;
        case lfoRateAddress:
            lfoRateRamper.setUIValue(clamp(value, 0.0f, 200.0f));
            break;
        default:
            EZKernelBase::setParameter(address, value);
    }
}

// Uses the ParameterAddress as a key
float EZFilterKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case lfoModAddress:
            return lfoModRamper.getUIValue();
        case lfoRateAddress:
            return lfoRateRamper.getUIValue();
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZFilterKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case lfoModAddress:
            lfoModRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        case lfoRateAddress:
            lfoRateRamper.startRamp(clamp(value, 0.0f, 200.0f), duration);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
    }
}

void EZFilterKernel::getAndSteps() {
    lfoMod = lfoModRamper.getAndStep();
    lfoRate = lfoRateRamper.getAndStep();
    EZKernelBase::standardEZFXGetAndSteps();
}
