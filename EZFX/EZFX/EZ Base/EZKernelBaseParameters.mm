//
//  EZKernelBaseParameters.m
//  AudioKit
//
//  Created by Colin on 09/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZKernelBase.hpp"

void EZKernelBase::setParameter(AUParameterAddress address, float value) {
        switch (address) {
               case xValueAddress:
                xValueRamper.setUIValue(clamp(value, -0.5f, 0.5f));
                break;
            case yValueAddress:
                yValueRamper.setUIValue(clamp(value, -0.5f, 0.5f));
                break;
            case isActiveAddress:
                isActiveRamper.setUIValue(clamp(value, 0.0f, 1.0f));
                break;
            case mixAddress:
                mixRamper.setUIValue(clamp(value, 0.0f, 1.0f));
                break;
            case outputLevelAddress:
                outputLevelRamper.setUIValue(clamp(value, -80.0f, 20.0f));
                break;
            case inputLevelAddress:
                inputLevelRamper.setUIValue(clamp(value, -80.0f, 20.0f));
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
         case mixAddress:
            return mixRamper.getUIValue();
        case outputLevelAddress:
            return outputLevelRamper.getUIValue();
        case inputLevelAddress:
            return inputLevelRamper.getUIValue();
        default:
            return 0;
    }
}

void EZKernelBase::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)  {
    
    switch (address) {
        case xValueAddress:
            xValueRamper.startRamp(clamp(value, -0.5f, 0.5f), duration);
            break;
        case yValueAddress:
            yValueRamper.startRamp(clamp(value, -0.5f, 0.5f), duration);
            break;
        case isActiveAddress:
            isActiveRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        case mixAddress:
            mixRamper.startRamp(clamp(value, 0.0f, 1.0f), duration);
            break;
        case outputLevelAddress:
            outputLevelRamper.startRamp(clamp(value, -80.0f, 20.0f), duration);
            break;
        case inputLevelAddress:
            inputLevelRamper.startRamp(clamp(value, -80.0f, 20.0f), duration);
            break;
    }
}

void EZKernelBase::standardEZFXGetAndSteps() {
    xValue = xValueRamper.getAndStep() + 0.5;
    yValue = yValueRamper.getAndStep() + 0.5;
    isActive = isActiveRamper.getAndStep();
    mix = mixRamper.getAndStep();
    outputLevel = powf(10, outputLevelRamper.getAndStep() / 20);
    inputLevel = powf(10, inputLevelRamper.getAndStep() / 20);
}
