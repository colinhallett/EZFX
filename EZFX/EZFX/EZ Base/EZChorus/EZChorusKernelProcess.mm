//
//  EZChorusKernelProcess.m
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZChorusKernel.hpp"

void EZChorusKernel::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float *inL = (float *)inBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *inR = (float *)inBufferListPtr->mBuffers[1].mData + bufferOffset;
    float *outL = (float *)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float *outR = (float *)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    EZKernelBase::standardEZFXGetAndSteps();
    
    if (EZKernelBase::isActive <= 0.5) {
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
        float xVal = EZKernelBase::xValue;
        float yVal = EZKernelBase::yValue;
        float outputLevel = EZKernelBase::outputLevel;
        float rampedXValue = 0;
        float rampedYValue = 0;
        float rampedInputLevel = 0;
        float rampedOutputLevel = 0;
        sp_port_compute(sp, internalXRamper, &xVal, &rampedXValue);
        sp_port_compute(sp, internalYRamper, &yVal, &rampedYValue);
        sp_port_compute(sp, internalOutputLevelRamper, &outputLevel, &rampedOutputLevel);
        sp_port_compute(sp, internalInputLevelRamper, &inputLevel, &rampedInputLevel);
        float mainInL = inL[i];
        float mainInR = inR[i];
        if (EZKernelBase::isActive <= 0.5) {
            mainInL = 0;
            mainInR = 0;
        }
        
        float inputLevelOutL = mainInL * rampedInputLevel;
        float inputLevelOutR = mainInR * rampedInputLevel;
        
        float inputSaturatorOutL, inputSaturatorOutR;
        sp_saturator_compute(sp, inputSaturatorL, &inputLevelOutL, &inputSaturatorOutL);
        sp_saturator_compute(sp, inputSaturatorR, &inputLevelOutR, &inputSaturatorOutR);
        
        float xPos = rampedXValue - 0.5;
        float yPos = rampedYValue - 0.5;
        float dFromO = distanceFromOrigin(xPos, yPos);//sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
           
        modOscillator.setFrequency(dFromO * 20.0f);
        flangeOscillator.setFrequency((1 - rampedYValue) * 10.0f);
        flangeModDepthFraction = dFromO;
        float delayFDB = 0.95 * rampedYValue;
        delayL->feedback = delayFDB;
        delayR->feedback = delayFDB;
        float filterFreq = 15000.0f * dFromO + 5000;
        filterL->freq = filterFreq;
        filterR->freq = filterFreq;
       
        float chorusOneInL = inputSaturatorOutL;
        float chorusOneInR = inputSaturatorOutR;
        float chorusOneOutL = 0.0f;
        float chorusOneOutR = 0.0f;
        
        float modLeft, modRight;
        modOscillator.getSamples(&modLeft, &modRight);
        
        float leftDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modRight;
        leftDelayLine.setDelayMs(leftDelayMs);
        rightDelayLine.setDelayMs(rightDelayMs);
        chorusOneOutL = leftDelayLine.push(chorusOneInL);
        chorusOneOutR = rightDelayLine.push(chorusOneInR);
        float chorusOneDelayL = 0.0f;
        float chorusOneDelayR = 0.0f;
        sp_delay_compute(sp, delayL, &chorusOneOutL, &chorusOneDelayL);
        sp_delay_compute(sp, delayR, &chorusOneOutR, &chorusOneDelayR);
        float chorusOnePShiftL = 0.0f;
        float chorusOnePShiftR = 0.0f;
        sp_pshift_compute(sp, pshiftL, &chorusOneDelayL, &chorusOnePShiftL);
        sp_pshift_compute(sp, pshiftR, &chorusOneDelayR, &chorusOnePShiftR);
        float chorusOneFilterL = 0.0f;
        float chorusOneFilterR = 0.0f;
        sp_butlp_compute(sp, filterL, &chorusOnePShiftL, &chorusOneFilterL);
        sp_butlp_compute(sp, filterR, &chorusOnePShiftR, &chorusOneFilterR);
        float chorusFlangeOutL = 0.0f;
        float chorusFlangeOutR = 0.0f;
        float flangeL, flangeR;
        flangeOscillator.getSamples(&flangeL, &flangeR);
        
        float leftFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeL;
        float rightFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeR;
        
        leftFlangeLine.setDelayMs(leftFlangeMs);
        rightFlangeLine.setDelayMs(rightFlangeMs);
        chorusFlangeOutL = leftFlangeLine.push(chorusOneFilterL);
        chorusFlangeOutR = rightFlangeLine.push(chorusOneFilterR);
        
        chorusFlangeOutL *= rampedOutputLevel;
        chorusFlangeOutR *= rampedOutputLevel;
        float mainOutL = 0;
        float mainOutR = 0;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &chorusFlangeOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &chorusFlangeOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
    }
};
