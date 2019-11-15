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
        
        rampedXValue = clamp(rampedXValue, 0.001f, 0.999f);
        rampedYValue = clamp(rampedYValue, 0.001f, 0.999f);
      /*  float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue - 0.5;
        float dFromO = distanceFromOrigin(xPos, yPos);*/
        
        float noiseOut, noiseHpfOut, randomOut;
        pinkNoise->amp = rampedNoiseLevel;
        
        sp_pinknoise_compute(sp, pinkNoise, NULL, &noiseOut);
        sp_buthp_compute(sp, noiseHpf, &noiseOut, &noiseHpfOut);
        sp_jitter_compute(sp, randomiser, NULL, &randomOut);
        
        float noiseMainOutL = inputLevelOutL + noiseHpfOut;
        float noiseMainOutR = inputLevelOutR + noiseHpfOut;
    
        float clipOutL, clipOutR;
        sp_clip_compute(sp, distClipL, &noiseMainOutL, &clipOutL);
        sp_clip_compute(sp, distClipL, &noiseMainOutR, &clipOutR);
        
        //saturator
    
        float saturatorDrive = 10 * rampedXValue + 0.5;
        float saturatorOffset = rampedYValue * 0.5 + 0.5;
        saturatorL->drive = saturatorDrive;
        saturatorL->dcoffset = saturatorOffset;
        saturatorR->drive = saturatorDrive;
        saturatorR->dcoffset = saturatorOffset;
        
        float saturatorOutL, saturatorOutR;
        sp_saturator_compute(sp, saturatorL, &clipOutL, &saturatorOutL);
        sp_saturator_compute(sp, saturatorR, &clipOutR, &saturatorOutR);
        
        //distortion
       
        
        float distortionOutL, distortionOutR;
        distL->pregain = 20 * rampedXValue + 0.1;
        distR->pregain = 20 * rampedXValue + 0.1;
        distL->shape1 = rampedYValue;
        distR->shape1 = rampedYValue;
        distL->shape2 = 1 - rampedYValue;
        distR->shape2 = 1 - rampedYValue;
        
        sp_dist_compute(sp, distL, &clipOutL, &distortionOutL);
        sp_dist_compute(sp, distR, &clipOutR, &distortionOutR);
        //bitcrush
        float bitCrushOutL, bitCrushOutR;
        bitcrushL->bitdepth = 16 - (15 * rampedYValue);
        bitcrushL->srate = 24001 - (24000 * rampedXValue);
        bitcrushR->bitdepth = 16 - (15 * rampedYValue);
        bitcrushR->srate = 24001 - (24000 * rampedXValue);
     
        sp_bitcrush_compute(sp, bitcrushL, &clipOutL, &bitCrushOutL);
        sp_bitcrush_compute(sp, bitcrushR, &clipOutR, &bitCrushOutR);
        //phase
        phasor->freq = 1000 * rampedYValue + 0.1;
        phaseDist->amount = rampedXValue * 2 - 1;
        float ph, pd, temp;
        
        sp_phasor_compute(sp, phasor, NULL, &ph);
        sp_pdhalf_compute(sp, phaseDist, &ph, &pd);
        tab->index = pd;
        sp_tabread_compute(sp, tab, NULL, &temp);
        float phaseOutL = clipOutL * temp;
        float phaseOutR = clipOutR * temp;
        //switch
        
        float crusherOutL, crusherOutR;
        
        switch (distType) {
            case 0:
                crusherOutL = saturatorOutL;
                crusherOutR = saturatorOutR;
                break;
            case 1:
                crusherOutL = distortionOutL;
                crusherOutR = distortionOutR;
                break;
            case 2:
                crusherOutL = bitCrushOutL;
                crusherOutR = bitCrushOutR;
                break;
            case 3:
                crusherOutL = phaseOutL;
                crusherOutR = phaseOutR;
                break;
            default:
                crusherOutL = 0;
                crusherOutR = 0;
                break;
        }
        
        float hpfOutL, hpfOutR;
        
        sp_buthp_compute(sp, outputHpfL, &crusherOutL, &hpfOutL);
        sp_buthp_compute(sp, outputHpfR, &crusherOutR, &hpfOutR);
      
        hpfOutL *= rampedOutputLevel;
        hpfOutR *= rampedOutputLevel;
        /*
        float compOutL, compOutR;
        float compRatio = rampedYValue * 5;
        float compThresh = 0 - rampedYValue * 10;
        *compL->ratio = compRatio;
        *compL->thresh = compThresh;
        *compR->ratio = compRatio;
        *compR->thresh = compThresh;
        
        sp_compressor_compute(sp, compL, &hpfOutL, &compOutL);
        sp_compressor_compute(sp, compL, &hpfOutR, &compOutR);
        
        compOutL *= rampedOutputLevel;
        compOutR *= rampedOutputLevel;
        */
        float mainOutL, mainOutR;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &hpfOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &hpfOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
