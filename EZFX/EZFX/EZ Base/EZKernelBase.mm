//
//  EZKernelBase.cpp
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#include "EZKernelBase.hpp"

void EZKernelBase::setParameter(AUParameterAddress address, float value) {
        switch (address) {
               case xValueAddress:
                xValueRamper.setUIValue(clamp(value, 0.0f, 1.0f));
                break;
            case yValueAddress:
                yValueRamper.setUIValue(clamp(value, 0.0f, 1.0f));
                break;
            case isActiveAddress:
                isActiveRamper.setUIValue(clamp(value, 0.0f, 1.0f));
                break;
        }
    
}

float EZKernelBase::getParameter(AUParameterAddress address) {
    switch (address) {
        case xValueAddress:
            return xValueRamper.getUIValue();
        case yValueAddress:
            return yValueRamper.getUIValue();
        case isActiveAddress:
            return isActiveRamper.getUIValue();
        default:
            return 0;
    }
}

void EZKernelBase::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)  {
    switch (address) {
        case xValueAddress:
            xValueRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        case yValueAddress:
            yValueRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        case isActiveAddress:
            isActiveRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
    }
}

void EZKernelBase::standardEZFXGetAndSteps() {
    xValue = xValueRamper.getAndStep();
    yValue = yValueRamper.getAndStep();
    isActive = isActiveRamper.getAndStep();
}

void EZKernelBase::init(int channelCount, double sampleRate)  {
    AKSoundpipeKernel::init(channelCount, sampleRate);
    xValueRamper.init();
    yValueRamper.init();
    isActiveRamper.init();
}

void EZKernelBase::reset() {
    xValueRamper.reset();
    yValueRamper.reset();
    isActiveRamper.reset();
}

void EZKernelBase::setXValue(float value) {
    xValue = clamp(value, 0.0f, 1.0f);
    xValueRamper.setImmediate(xValue);
}

void EZKernelBase::setYValue(float value) {
    yValue = clamp(value, 0.0f, 1.0f);
    yValueRamper.setImmediate(yValue);
}

void EZKernelBase::setIsActive(float value) {
    isActive = clamp(value, 0.0f, 1.0f);
    isActiveRamper.setImmediate(isActive);
}

