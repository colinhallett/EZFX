//
//  EZKernelBaseSetValues.m
//  AudioKit
//
//  Created by Colin on 09/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZKernelBase.hpp"

void EZKernelBase::setXValue(float value) {
    xValue = clamp(value, -0.5f, 0.5f);
    xValueRamper.setImmediate(xValue);
}

void EZKernelBase::setYValue(float value) {
    yValue = clamp(value, -0.5f, 0.5f);
    yValueRamper.setImmediate(yValue);
}

void EZKernelBase::setIsActive(float value) {
    isActive = clamp(value, 0.0f, 1.0f);
    isActiveRamper.setImmediate(isActive);
}

void EZKernelBase::setMix(float value) {
    mix = clamp (value, 0.0f, 1.0f);
    mixRamper.setImmediate(mix);
}
void EZKernelBase::setOutputLevel(float value) {
    outputLevel = clamp(value, 0.0f, 1.0f);
    outputLevelRamper.setImmediate(outputLevel);
}
void EZKernelBase::setInputLevel(float value) {
    inputLevel = clamp(value, 0.0f, 1.0f);
    inputLevelRamper.setImmediate(inputLevel);
}
