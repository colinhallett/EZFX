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

    initBP(&trackerData->bp1L, &trackerData->bp1R, &trackerData->bp1RMSL, &trackerData->bp1RMSR);
    initBP(&trackerData->bp4L, &trackerData->bp4R, &trackerData->bp4RMSL, &trackerData->bp4RMSR);
    initBP(&trackerData->bp8L, &trackerData->bp8R, &trackerData->bp8RMSL, &trackerData->bp8RMSR);
    
    float bandWidth = 5000;
    trackerData->bp1L->bw = bandWidth;
    trackerData->bp1R->bw = bandWidth;
    trackerData->bp4L->bw = bandWidth;
    trackerData->bp4R->bw = bandWidth;
    trackerData->bp8L->bw = bandWidth;
    trackerData->bp8R->bw = bandWidth;
    
  
    trackerData->bp1L->freq = 200.0f;
    trackerData->bp1R->freq = 200.f;
    
    trackerData->bp4L->freq = 4000.0f;
    trackerData->bp4R->freq = 4000.0f;
    
    trackerData->bp8L->freq = 10000.0f;
    trackerData->bp8R->freq = 10000.0f;
}

void EZKernelBase::resetTracker() {
   
}
