//
//  EZKernelBaseAmplitudes.m
//  AudioKit
//
//  Created by Colin on 09/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#include "EZKernelBase.hpp"

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
   
    bp1Amp = computeBP(trackerData->bp1L, trackerData->bp1R, trackerData->bp1RMSL, trackerData->bp1RMSL, inputL, inputR);
    bp2Amp = computeBP(trackerData->bp2L, trackerData->bp2R, trackerData->bp2RMSL, trackerData->bp2RMSL, inputL, inputR);
    bp3Amp = computeBP(trackerData->bp3L, trackerData->bp3R, trackerData->bp3RMSL, trackerData->bp3RMSL, inputL, inputR);
    bp4Amp = computeBP(trackerData->bp4L, trackerData->bp4R, trackerData->bp4RMSL, trackerData->bp4RMSL, inputL, inputR);
    bp5Amp = computeBP(trackerData->bp5L, trackerData->bp5R, trackerData->bp5RMSL, trackerData->bp5RMSL, inputL, inputR);
    bp6Amp = computeBP(trackerData->bp6L, trackerData->bp6R, trackerData->bp6RMSL, trackerData->bp6RMSL, inputL, inputR);
    bp7Amp = computeBP(trackerData->bp7L, trackerData->bp7R, trackerData->bp7RMSL, trackerData->bp7RMSL, inputL, inputR);
    bp8Amp = computeBP(trackerData->bp8L, trackerData->bp8R, trackerData->bp8RMSL, trackerData->bp8RMSL, inputL, inputR);
    highCutAmplitude = computeHP(trackerData->highCutL, trackerData->highCutR, trackerData->highCutRMSL, trackerData->highCutRMSR, inputL, inputR);
}
