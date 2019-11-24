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
        case brightnessAddress:
            brightnessRamper.setUIValue(clamp(value, 0.0f, 1.0f));
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
        case brightnessAddress:
            return brightnessRamper.getUIValue();
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZSpacerKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case predelayAddress:
            predelayRamper.startRamp(clamp(value, 0.0f, 1000.0f), duration);
            break;
        case brightnessAddress:
            brightnessRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
    }
}

void EZSpacerKernel::getAndSteps() {
    predelay = predelayRamper.getAndStep();
    brightness = brightnessRamper.getAndStep();
    EZKernelBase::standardEZFXGetAndSteps();
}
