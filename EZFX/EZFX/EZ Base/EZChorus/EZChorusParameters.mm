//
//  EZChorusParameters.m
//  AudioKit
//
//  Created by Colin on 19/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZChorusKernel.hpp"

void EZChorusKernel::setParameter(AUParameterAddress address, float value) {
    switch (address) {
        case modulationTypeAddress:
            modulationType = int(value);
            break;
        case widenAddress:
            widenRamper.setImmediate(clamp(value, 0.0f, 1.0f));
            break;
        default:
            EZKernelBase::setParameter(address, value);
    }
}

float EZChorusKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case modulationTypeAddress:
            return modulationType;
        case widenAddress:
            return widenRamper.getUIValue();
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZChorusKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case modulationTypeAddress:
            modulationType = int(value);
            break;
        case widenAddress:
            widenRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
            break;
    }
}

void EZChorusKernel::getAndStep() {
    EZKernelBase::standardEZFXGetAndSteps();
    widen = widenRamper.getAndStep();
}
