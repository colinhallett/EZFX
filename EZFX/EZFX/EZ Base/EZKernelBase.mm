//
//  EZKernelBase.cpp
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#include "EZKernelBase.hpp"
#include <iostream>

struct EZKernelBase::TrackerData {
    sp_rms *lowRMSL;
    sp_rms *lowRMSR;
    sp_butlp *lowCutL;
    sp_butlp *lowCutR;
    
    sp_rms *lowMidRMSL;
    sp_rms *lowMidRMSR;
    sp_butbp *lowMidBPL;
    sp_butbp *lowMidBPR;
    
    sp_rms *highMidRMSL;
    sp_rms *highMidRMSR;
    sp_butbp *highMidBPL;
    sp_butbp *highMidBPR;
    
    sp_rms *lowHighRMSL;
    sp_rms *lowHighRMSR;
    sp_butbp *lowHighBPL;
    sp_butbp *lowHighBPR;
    
    sp_rms *highHighRMSL;
    sp_rms *highHighRMSR;
    sp_buthp *highCutL;
    sp_buthp *highCutR;
};

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
            case mixAddress:
                mixRamper.setUIValue(clamp(value, 0.0f, 1.0f));
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
    }
}

void EZKernelBase::standardEZFXGetAndSteps() {
    xValue = xValueRamper.getAndStep() + 0.5;
    yValue = yValueRamper.getAndStep() + 0.5;
    isActive = isActiveRamper.getAndStep();
    mix = mixRamper.getAndStep();
    mixL->pos = mix;
    mixR->pos = mix;
}

void EZKernelBase::init(int channelCount, double sampleRate)  {
    AKSoundpipeKernel::init(channelCount, sampleRate);
    trackerData.reset(new TrackerData);
    xValueRamper.init();
    yValueRamper.init();
    isActiveRamper.init();
    mixRamper.init();
    initCrossfade();
    initTracker();
    initRamper();
}

void EZKernelBase::reset() {
    xValueRamper.reset();
    yValueRamper.reset();
    isActiveRamper.reset();
    mixRamper.reset();
    if (sp) {
        resetCrossfade();
        resetTracker();
        resetRamper();
    }
    
    resetted = true;
}

void EZKernelBase::initRamper() {
    sp_port_create(&internalXRamper);
    sp_port_init(sp, internalXRamper, 0.1);
    sp_port_create(&internalYRamper);
    sp_port_init(sp, internalYRamper, 0.1);
}
void EZKernelBase::resetRamper() {
    sp_port_destroy(&internalXRamper);
    sp_port_destroy(&internalYRamper);
    initRamper();
}

void EZKernelBase::resetCrossfade() {
    sp_crossfade_destroy(&mixL);
    sp_crossfade_destroy(&mixR);
    initCrossfade();
}
void EZKernelBase::initCrossfade() {
    sp_crossfade_create(&mixL);
    sp_crossfade_init(sp, mixL);
    sp_crossfade_create(&mixR);
    sp_crossfade_init(sp, mixR);
}

void EZKernelBase::initTracker() {
    sp_rms_create(&trackerData->lowRMSL);
    sp_rms_create(&trackerData->lowRMSR);
    sp_butlp_create(&trackerData->lowCutL);
    sp_butlp_create(&trackerData->lowCutR);
    sp_rms_init(sp, trackerData->lowRMSL);
    sp_rms_init(sp, trackerData->lowRMSR);
    sp_butlp_init(sp, trackerData->lowCutL);
    sp_butlp_init(sp, trackerData->lowCutR);

    sp_rms_create(&trackerData->lowMidRMSL);
    sp_rms_create(&trackerData->lowMidRMSR);
    sp_butbp_create(&trackerData->lowMidBPL);
    sp_butbp_create(&trackerData->lowMidBPR);
    sp_rms_init(sp, trackerData->lowMidRMSL);
    sp_rms_init(sp, trackerData->lowMidRMSR);
    sp_butbp_init(sp, trackerData->lowMidBPL);
    sp_butbp_init(sp, trackerData->lowMidBPR);
    
    sp_rms_create(&trackerData->highMidRMSL);
    sp_rms_create(&trackerData->highMidRMSR);
    sp_butbp_create(&trackerData->highMidBPL);
    sp_butbp_create(&trackerData->highMidBPR);
    sp_rms_init(sp, trackerData->highMidRMSL);
    sp_rms_init(sp, trackerData->highMidRMSR);
    sp_butbp_init(sp, trackerData->highMidBPL);
    sp_butbp_init(sp, trackerData->highMidBPR);
    
    sp_rms_create(&trackerData->lowHighRMSL);
    sp_rms_create(&trackerData->lowHighRMSR);
    sp_butbp_create(&trackerData->lowHighBPL);
    sp_butbp_create(&trackerData->lowHighBPR);
    sp_rms_init(sp, trackerData->lowHighRMSL);
    sp_rms_init(sp, trackerData->lowHighRMSR);
    sp_butbp_init(sp, trackerData->lowHighBPL);
    sp_butbp_init(sp, trackerData->lowHighBPR);
    
    sp_rms_create(&trackerData->highHighRMSL);
    sp_rms_create(&trackerData->highHighRMSR);
    sp_buthp_create(&trackerData->highCutL);
    sp_buthp_create(&trackerData->highCutR);
    sp_rms_init(sp, trackerData->highHighRMSL);
    sp_rms_init(sp, trackerData->highHighRMSR);
    sp_buthp_init(sp, trackerData->highCutL);
    sp_buthp_init(sp, trackerData->highCutR);
    
    trackerData->lowCutL->freq = 100;
    trackerData->lowCutR->freq = 100;
    trackerData->lowMidBPL->freq = 300;
    trackerData->lowMidBPR->freq = 300;
    trackerData->highMidBPL->freq = 1000;
    trackerData->highMidBPR->freq = 1000;
    trackerData->lowHighBPL->freq = 4000;
    trackerData->lowHighBPR->freq = 4000;
    trackerData->highCutL->freq = 10000;
    trackerData->highCutR->freq = 10000;
}

void EZKernelBase::resetTracker() {
    sp_rms_destroy(&trackerData->lowRMSL);
    sp_rms_destroy(&trackerData->lowRMSR);
    sp_butlp_destroy(&trackerData->lowCutL);
    sp_butlp_destroy(&trackerData->lowCutR);
    
    sp_rms_destroy(&trackerData->lowMidRMSL);
    sp_rms_destroy(&trackerData->lowMidRMSR);
    sp_butbp_destroy(&trackerData->lowMidBPL);
    sp_butbp_destroy(&trackerData->lowMidBPR);
    
    sp_rms_destroy(&trackerData->highMidRMSL);
    sp_rms_destroy(&trackerData->highMidRMSR);
    sp_butbp_destroy(&trackerData->highMidBPL);
    sp_butbp_destroy(&trackerData->highMidBPR);
    
    sp_rms_destroy(&trackerData->lowHighRMSL);
    sp_rms_destroy(&trackerData->lowHighRMSR);
    sp_butbp_destroy(&trackerData->lowHighBPL);
    sp_butbp_destroy(&trackerData->lowHighBPR);
    
    sp_rms_destroy(&trackerData->highHighRMSL);
    sp_rms_destroy(&trackerData->highHighRMSR);
    sp_buthp_destroy(&trackerData->highCutL);
    sp_buthp_destroy(&trackerData->highCutR);
    
    initTracker();
}

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

void EZKernelBase::calculateAmplitudes(float inputL, float inputR) {
    float lowCutL, lowCutR;
    sp_butlp_compute(sp, trackerData->lowCutL, &inputL, &lowCutL);
    sp_butlp_compute(sp, trackerData->lowCutR, &inputR, &lowCutR);
    float lowAmpL, lowAmpR;
    sp_rms_compute(sp, trackerData->lowRMSL, &lowCutL, &lowAmpL);
    sp_rms_compute(sp, trackerData->lowRMSR, &lowCutR, &lowAmpR);
    lowAmplitude = (lowAmpL + lowAmpR) / 2;
    
    float lowMidCutL, lowMidCutR;
    sp_butbp_compute(sp, trackerData->lowMidBPL, &inputL, &lowMidCutL);
    sp_butbp_compute(sp, trackerData->lowMidBPR, &inputR, &lowMidCutR);
    float lowMidAmpL, lowMidAmpR;
    sp_rms_compute(sp, trackerData->lowMidRMSL, &lowMidCutL, &lowMidAmpL);
    sp_rms_compute(sp, trackerData->lowMidRMSR, &lowMidCutR, &lowMidAmpR);
    lowMidAmplitude = (lowMidAmpL + lowMidAmpR) / 2;
    
    float highMidCutL, highMidCutR;
    sp_butbp_compute(sp, trackerData->highMidBPL, &inputL, &highMidCutL);
    sp_butbp_compute(sp, trackerData->highMidBPR, &inputR, &highMidCutR);
    float highMidAmpL, highMidAmpR;
    sp_rms_compute(sp, trackerData->highMidRMSL, &highMidCutL, &highMidAmpL);
    sp_rms_compute(sp, trackerData->highMidRMSR, &highMidCutR, &highMidAmpR);
    highMidAmplitude = (highMidAmpL + highMidAmpR) / 2;
    
    float lowHighCutL, lowHighCutR;
    sp_butbp_compute(sp, trackerData->lowHighBPL, &inputL, &lowHighCutL);
    sp_butbp_compute(sp, trackerData->lowHighBPR, &inputR, &lowHighCutR);
    float lowHighAmpL, lowHighAmpR;
    sp_rms_compute(sp, trackerData->lowHighRMSL, &lowHighCutL, &lowHighAmpL);
    sp_rms_compute(sp, trackerData->lowHighRMSR, &lowHighCutR, &lowHighAmpR);
    lowHighAmplitude = (lowHighAmpL + lowHighAmpR) / 2;
    
    float highCutL, highCutR;
    sp_buthp_compute(sp, trackerData->highCutL, &inputL, &highCutL);
    sp_buthp_compute(sp, trackerData->highCutR, &inputR, &highCutR);
    float highAmpL, highAmpR;
    sp_rms_compute(sp, trackerData->highHighRMSL, &highCutL, &highAmpL);
    sp_rms_compute(sp, trackerData->highHighRMSR, &highCutR, &highAmpR);
    highHighAmplitude = (highAmpL + highAmpR) / 2;
    
}
