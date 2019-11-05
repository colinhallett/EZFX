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
    
  /*  sp_rms *bp1RMSL;
    sp_rms *bp1RMSR;
    sp_butbp *bp1L;
    sp_butbp *bp1R;*/
    
    /*sp_rms *bp2RMSL;
    sp_rms *bp2RMSR;
    sp_butbp *bp2L;
    sp_butbp *bp2R;
    
    sp_rms *bp3RMSL;
    sp_rms *bp3RMSR;
    sp_butbp *bp3L;
    sp_butbp *bp3R;
    
    sp_rms *bp4RMSL;
    sp_rms *bp4RMSR;
    sp_butbp *bp4L;
    sp_butbp *bp4R;
    
    sp_rms *bp5RMSL;
    sp_rms *bp5RMSR;
    sp_butbp *bp5L;
    sp_butbp *bp5R;
    
    sp_rms *bp6RMSL;
    sp_rms *bp6RMSR;
    sp_butbp *bp6L;
    sp_butbp *bp6R;
    
    sp_rms *bp7RMSL;
    sp_rms *bp7RMSR;
    sp_butbp *bp7L;
    sp_butbp *bp7R;
    
    sp_rms *bp8RMSL;
    sp_rms *bp8RMSR;
    sp_butbp *bp8L;
    sp_butbp *bp8R;*/
    
    sp_rms *highCutRMSL;
    sp_rms *highCutRMSR;
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

void EZKernelBase::initBP(sp_butbp **filL, sp_butbp **filR, sp_rms **rmsL, sp_rms **rmsR) {
    sp_rms_create(rmsL);
    sp_rms_create(rmsR);
    sp_rms_init(sp, *rmsL);
    sp_rms_init(sp, *rmsR);
    sp_butbp_create(filL);
    sp_butbp_create(filR);
    sp_butbp_init(sp, *filL);
    sp_butbp_init(sp, *filR);
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
/*
    initBP(&trackerData->bp1L, &trackerData->bp1R, &trackerData->bp1RMSL, &trackerData->bp1RMSR);
    */
    sp_rms_create(&trackerData->highCutRMSL);
    sp_rms_create(&trackerData->highCutRMSR);
    sp_buthp_create(&trackerData->highCutL);
    sp_buthp_create(&trackerData->highCutR);
    sp_rms_init(sp, trackerData->highCutRMSL);
    sp_rms_init(sp, trackerData->highCutRMSR);
    sp_buthp_init(sp, trackerData->highCutL);
    sp_buthp_init(sp, trackerData->highCutR);
    
    
    float freqs[10] = {50.f, 100.f, 200.f, 400.f, 800.f, 1600.f, 3200.f, 6400.f, 12800.f, 15000.f};
    
    trackerData->lowCutL->freq = 50.f;
    trackerData->lowCutR->freq = 50.f;
 /*   trackerData->bp1L->freq = 100.f;
    trackerData->bp1R->freq = 100.f;*/
    
    /*trackerData->bp2L->freq = freqs[2];
    trackerData->bp2R->freq = freqs[2];
    
    trackerData->bp3L->freq = freqs[3];
    trackerData->bp3R->freq = freqs[3];
    
    trackerData->bp4L->freq = freqs[4];
    trackerData->bp4R->freq = freqs[4];
    
    trackerData->bp5L->freq = freqs[5];
    trackerData->bp5R->freq = freqs[5];
    
    trackerData->bp6L->freq = freqs[6];
    trackerData->bp6R->freq = freqs[6];
    
    trackerData->bp7L->freq = freqs[7];
    trackerData->bp7R->freq = freqs[7];
    
    trackerData->bp8L->freq = freqs[8];
    trackerData->bp8R->freq = freqs[8];*/
    
    trackerData->highCutL->freq = 15000.f;
    trackerData->highCutR->freq = 15000.f;
}

void EZKernelBase::resetTracker() {
   
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


float EZKernelBase::computeLP(sp_butlp *filL, sp_butlp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR) {
    float fOutL, fOutR;
    sp_butlp_compute(sp, filL, &inL, &fOutL);
    sp_butlp_compute(sp, filR, &inR, &fOutR);
    float rmsOutL, rmsOutR;
    sp_rms_compute(sp, rmsL, &fOutL, &rmsOutL);
    sp_rms_compute(sp, rmsL, &fOutR, &rmsOutR);
    return ((rmsOutL + rmsOutR) / 2);
}
float EZKernelBase::computeHP(sp_buthp *filL, sp_buthp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR) {
    float fOutL, fOutR;
    sp_buthp_compute(sp, filL, &inL, &fOutL);
    sp_buthp_compute(sp, filR, &inR, &fOutR);
    float rmsOutL, rmsOutR;
    sp_rms_compute(sp, rmsL, &fOutL, &rmsOutL);
    sp_rms_compute(sp, rmsL, &fOutR, &rmsOutR);
    return ((rmsOutL + rmsOutR) / 2);
}
float EZKernelBase::computeBP(sp_butbp *filL, sp_butbp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR) {
    float fOutL, fOutR;
    sp_butbp_compute(sp, filL, &inL, &fOutL);
    sp_butbp_compute(sp, filR, &inR, &fOutR);
    float rmsOutL, rmsOutR;
    sp_rms_compute(sp, rmsL, &fOutL, &rmsOutL);
    sp_rms_compute(sp, rmsL, &fOutR, &rmsOutR);
    return ((rmsOutL + rmsOutR) / 2);
}

void EZKernelBase::calculateAmplitudes(float inputL, float inputR) {
    lowAmplitude = computeLP(trackerData->lowCutL, trackerData->lowCutR, trackerData->lowRMSL, trackerData->lowRMSR, inputL, inputR);
   /*
    bp1Amp = computeBP(trackerData->bp1L, trackerData->bp1R, trackerData->bp1RMSL, trackerData->bp1RMSL, inputL, inputR);*/
   /* bp2Amp = computeBP(trackerData->bp2L, trackerData->bp2R, trackerData->bp2RMSL, trackerData->bp2RMSL, inputL, inputR);
    bp3Amp = computeBP(trackerData->bp3L, trackerData->bp3R, trackerData->bp3RMSL, trackerData->bp3RMSL, inputL, inputR);
    bp4Amp = computeBP(trackerData->bp4L, trackerData->bp4R, trackerData->bp4RMSL, trackerData->bp4RMSL, inputL, inputR);
    bp5Amp = computeBP(trackerData->bp5L, trackerData->bp5R, trackerData->bp5RMSL, trackerData->bp5RMSL, inputL, inputR);
    bp6Amp = computeBP(trackerData->bp6L, trackerData->bp6R, trackerData->bp6RMSL, trackerData->bp6RMSL, inputL, inputR);
    bp7Amp = computeBP(trackerData->bp7L, trackerData->bp7R, trackerData->bp7RMSL, trackerData->bp7RMSL, inputL, inputR);
    bp8Amp = computeBP(trackerData->bp8L, trackerData->bp8R, trackerData->bp8RMSL, trackerData->bp8RMSL, inputL, inputR);*/
    highCutAmplitude = computeHP(trackerData->highCutL, trackerData->highCutR, trackerData->highCutRMSL, trackerData->highCutRMSR, inputL, inputR);
}
