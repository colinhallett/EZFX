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
        default:
            EZKernelBase::setParameter(address, value);
    }
}

float EZChorusKernel::getParameter(AUParameterAddress address) {
    switch (address) {
        case modulationTypeAddress:
            return modulationType;
        default:
            return EZKernelBase::getParameter(address);
    }
}

void EZChorusKernel::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) {
    switch (address) {
        case modulationTypeAddress:
            modulationType = int(value);
            break;
        default:
            EZKernelBase::startRamp(address, value, duration);
            break;
    }
}
