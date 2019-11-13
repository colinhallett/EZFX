//
//  EZKernelBase.cpp
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#include "EZKernelBase.hpp"
#include <iostream>

void EZKernelBase::init(int channelCount, double sampleRate)  {
    AKSoundpipeKernel::init(channelCount, sampleRate);
    trackerData.reset(new TrackerData);
    xValueRamper.init();
    yValueRamper.init();
    isActiveRamper.init();
    mixRamper.init();
    outputLevelRamper.init();
    inputLevelRamper.init();
    initCrossfade();
    initTracker();
    initRamper();
}

void EZKernelBase::reset() {
    xValueRamper.reset();
    yValueRamper.reset();
    isActiveRamper.reset();
    mixRamper.reset();
    inputLevelRamper.reset();
    outputLevelRamper.reset();
    if (sp) {
        resetCrossfade();
        resetTracker();
        resetRamper();
    }
    
    resetted = true;
}

void EZKernelBase::initRamper() {
    sp_port_create(&internalXRamper);
    sp_port_init(sp, internalXRamper, 0.01);
    sp_port_create(&internalYRamper);
    sp_port_init(sp, internalYRamper, 0.01);
    sp_port_create(&internalOutputLevelRamper);
    sp_port_init(sp, internalOutputLevelRamper, 0.01);
    sp_port_create(&internalInputLevelRamper);
    sp_port_init(sp, internalInputLevelRamper, 0.01);
}
void EZKernelBase::resetRamper() {
    sp_port_destroy(&internalXRamper);
    sp_port_destroy(&internalYRamper);
    sp_port_destroy(&internalOutputLevelRamper);
    sp_port_destroy(&internalInputLevelRamper);
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

    initBP(&trackerData->bp1L, &trackerData->bp1R, &trackerData->bp1RMSL, &trackerData->bp1RMSR);
    initBP(&trackerData->bp2L, &trackerData->bp2R, &trackerData->bp2RMSL, &trackerData->bp2RMSR);
    initBP(&trackerData->bp3L, &trackerData->bp3R, &trackerData->bp3RMSL, &trackerData->bp3RMSR);
    initBP(&trackerData->bp4L, &trackerData->bp4R, &trackerData->bp4RMSL, &trackerData->bp4RMSR);
    initBP(&trackerData->bp5L, &trackerData->bp5R, &trackerData->bp5RMSL, &trackerData->bp5RMSR);
    initBP(&trackerData->bp6L, &trackerData->bp6R, &trackerData->bp6RMSL, &trackerData->bp6RMSR);
    initBP(&trackerData->bp7L, &trackerData->bp7R, &trackerData->bp7RMSL, &trackerData->bp7RMSR);
    initBP(&trackerData->bp8L, &trackerData->bp8R, &trackerData->bp8RMSL, &trackerData->bp8RMSR);
    
    sp_rms_create(&trackerData->highCutRMSL);
    sp_rms_create(&trackerData->highCutRMSR);
    sp_buthp_create(&trackerData->highCutL);
    sp_buthp_create(&trackerData->highCutR);
    sp_rms_init(sp, trackerData->highCutRMSL);
    sp_rms_init(sp, trackerData->highCutRMSR);
    sp_buthp_init(sp, trackerData->highCutL);
    sp_buthp_init(sp, trackerData->highCutR);
    
    float bandWidth = 5000;
    trackerData->bp1L->bw = bandWidth;
    trackerData->bp1R->bw = bandWidth;
    trackerData->bp2L->bw = bandWidth;
    trackerData->bp2R->bw = bandWidth;
    trackerData->bp3L->bw = bandWidth;
    trackerData->bp3R->bw = bandWidth;
    trackerData->bp4L->bw = bandWidth;
    trackerData->bp4R->bw = bandWidth;
    trackerData->bp5L->bw = bandWidth;
    trackerData->bp5R->bw = bandWidth;
    trackerData->bp6L->bw = bandWidth;
    trackerData->bp6R->bw = bandWidth;
    trackerData->bp7L->bw = bandWidth;
    trackerData->bp7R->bw = bandWidth;
    trackerData->bp8L->bw = bandWidth;
    trackerData->bp8R->bw = bandWidth;
    
    float freqs[10] = {50.f, 100.f, 200.f, 400.f, 800.f, 1600.f, 3200.f, 6400.f, 12800.f, 15000.f};
    
    trackerData->lowCutL->freq = 50.f;
    trackerData->lowCutR->freq = 50.f;
    trackerData->bp1L->freq = 200.0f;
    trackerData->bp1R->freq = 200.f;
    
    trackerData->bp2L->freq = freqs[2];
    trackerData->bp2R->freq = freqs[2];
    
    trackerData->bp3L->freq = freqs[3];
    trackerData->bp3R->freq = freqs[3];
    
    trackerData->bp4L->freq = 4000.0f;
    trackerData->bp4R->freq = 4000.0f;
    
    trackerData->bp5L->freq = freqs[5];
    trackerData->bp5R->freq = freqs[5];
    
    trackerData->bp6L->freq = freqs[6];
    trackerData->bp6R->freq = freqs[6];
    
    trackerData->bp7L->freq = freqs[7];
    trackerData->bp7R->freq = freqs[7];
    
    trackerData->bp8L->freq = 10000.0f;
    trackerData->bp8R->freq = 10000.0f;
    
    trackerData->highCutL->freq = 15000.f;
    trackerData->highCutR->freq = 15000.f;
}

void EZKernelBase::resetTracker() {
   
}
