//
//  EZCrusherProcess.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZCrusherKernel.hpp"

void EZCrusherKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    getAndSteps();
    
    if (EZKernelBase::isActive == 0) {
        for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
            outL[i] = inL[i];
            outR[i] = inR[i];
            calculateAmplitudes(outL[i], outR[i]);
        }
        resetFX();
        return;
    } else {
        fxResetted = false;
    }
    
    for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
        float mainInL = inL[i];
        float mainInR = inR[i];
       
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float outputLevel = EZKernelBase::outputLevel;
        float rampedXValue = 0;
        float rampedYValue = 0;
        float rampedOutputLevel = 0;
        float rampedNoiseLevel = 0;
        float rampedInputLevel = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalInputLevelRamper, &inputLevel, &rampedInputLevel);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        sp_port_compute(sp, noiseLevelInternalRamper, &noiseLevel, &rampedNoiseLevel);
        
        float inputLevelOutL = mainInL * rampedInputLevel;
        float inputLevelOutR = mainInR * rampedInputLevel;
        
        rampedNoiseLevel = expValue(rampedNoiseLevel, 4) * 0.25;
        float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue - 0.5;
        float dFromO = distanceFromOrigin(xPos, yPos);
        
        float noiseOut, noiseHpfOut, randomOut;
        pinkNoise->amp = rampedNoiseLevel;
        
        sp_pinknoise_compute(sp, pinkNoise, NULL, &noiseOut);
        sp_buthp_compute(sp, noiseHpf, &noiseOut, &noiseHpfOut);
        sp_jitter_compute(sp, randomiser, NULL, &randomOut);
        
        //noiseHpfOut *= (randomOut);
        float saturatorInL = inputLevelOutL + noiseHpfOut;
        float saturatorInR = inputLevelOutR + noiseHpfOut;
        
        float saturatorDrive = 20 * rampedXValue + 0.5;
        float saturatorOffset = 1 * rampedYValue;
        saturatorL->drive = saturatorDrive;
        saturatorL->dcoffset = saturatorOffset;
        saturatorR->drive = saturatorDrive;
        saturatorR->dcoffset = saturatorOffset;
        
        float saturatorOutL, saturatorOutR;
        sp_saturator_compute(sp, saturatorL, &saturatorInL, &saturatorOutL);
        sp_saturator_compute(sp, saturatorR, &saturatorInR, &saturatorOutR);
        
        float hpfOutL, hpfOutR;
        
        sp_buthp_compute(sp, outputHpfL, &saturatorOutL, &hpfOutL);
        sp_buthp_compute(sp, outputHpfR, &saturatorOutR, &hpfOutR);
        
        float compOutL, compOutR;
        float compRatio = rampedYValue * 20;
        float compThresh = 0 - rampedYValue * 40;
        *compL->ratio = compRatio;
        *compL->thresh = compThresh;
        *compR->ratio = compRatio;
        *compR->thresh = compThresh;
        
        sp_compressor_compute(sp, compL, &hpfOutL, &compOutL);
        sp_compressor_compute(sp, compL, &hpfOutR, &compOutR);
        
        compOutL *= rampedOutputLevel;
        compOutR *= rampedOutputLevel;
        
        float mainOutL, mainOutR;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &compOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &compOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
