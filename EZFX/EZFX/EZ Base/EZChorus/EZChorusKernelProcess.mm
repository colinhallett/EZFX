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
        
        //chorus
        chorusModOscillator.setFrequency(rampedYValue * 10.0f + 0.0001);
        
        float chorusOutL, chorusOutR;
        
        float chorusOneInL = inputSaturatorOutL;
        float chorusOneInR = inputSaturatorOutR;
        
        float modLeft, modRight;
        chorusModOscillator.getSamples(&modLeft, &modRight);
       
        float leftDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modRight;
        chorusDelayLineL.setDelayMs(leftDelayMs);
        chorusDelayLineR.setDelayMs(rightDelayMs);
        chorusOutL = chorusDelayLineL.push(chorusOneInL);
        chorusOutR = chorusDelayLineR.push(chorusOneInR);
        
        //phase
        float phaseOutL, phaseOutR;
        
        *phaser->depth = rampedYValue;//dFromO * 0.8 + 0.1;
        *phaser->feedback_gain = rampedXValue * 0.8 + 0.1;
       // *phaser->NotchFreq = 1.2 + 3.6 * rampedYValue;
       // *phaser->Notch_width = 100 + 489 * rampedXValue;
       // *phaser->MaxNotch1Freq = 3000 + 2000 * dFromO;
        //*phaser->MinNotch1Freq = 1000 + 2000 * dFromO;
        *phaser->lfobpm = 1 + 30 * rampedXValue;
        sp_phaser_compute(sp, phaser, &inputSaturatorOutL, &inputSaturatorOutR, &phaseOutL, &phaseOutR);
       
        //flange
        float flangeOutL, flangeOutR;
        float flangeL, flangeR;
        flangeOscillator.setFrequency(rampedYValue * 20.0f + 0.01);
        leftFlangeLine.setFeedback(0.2 * rampedXValue + 0.05);
        rightFlangeLine.setFeedback(0.3 * rampedXValue + 0.05);
        
        flangeModDepthFraction = 0.2 * rampedYValue + 0.05;

        
       flangeOscillator.getSamples(&flangeL, &flangeR);
       
       float leftFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeL;
       float rightFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeR;
       
       leftFlangeLine.setDelayMs(leftFlangeMs);
       rightFlangeLine.setDelayMs(rightFlangeMs);
       flangeOutL = leftFlangeLine.push(inputSaturatorOutL);
       flangeOutR = rightFlangeLine.push(inputSaturatorOutR);
       
        
        //panner
        float pannerOutL, pannerOutR;
        pannerOutL = pannerOutR = 0;
        
        //switch
        float fxOutL, fxOutR;
        
        switch (modulationType) {
            case 0:
                fxOutL = chorusOutL;
                fxOutR = chorusOutR;
                break;
            case 1:
                fxOutL = phaseOutL;
                fxOutR = phaseOutR;
                break;
            case 2:
                fxOutL = flangeOutL;
                fxOutR = flangeOutR;
                break;
            case 3:
                fxOutL = pannerOutL;
                fxOutR = pannerOutR;
                break;
            default:
                fxOutL = 0;
                fxOutR = 0;
        }
        
        //after switch
        float delayFDB = 0.6 * rampedYValue;
        delayL->time = 0.02 * rampedXValue;
        delayR->time = 0.04 - 0.04 * rampedXValue;
        delayL->feedback = delayFDB;
        delayR->feedback = delayFDB;
        float filterFreq = 7000; //* dFromO + 5000;
        filterL->freq = filterFreq;
        filterR->freq = filterFreq;
        
        float chorusOneDelayL = 0.0f;
        float chorusOneDelayR = 0.0f;
        sp_delay_compute(sp, delayL, &fxOutL, &chorusOneDelayL);
        sp_delay_compute(sp, delayR, &fxOutR, &chorusOneDelayR);
        float chorusOnePShiftL = 0.0f;
        float chorusOnePShiftR = 0.0f;
        sp_pshift_compute(sp, pshiftL, &chorusOneDelayL, &chorusOnePShiftL);
        sp_pshift_compute(sp, pshiftR, &chorusOneDelayR, &chorusOnePShiftR);
        float chorusOneFilterL = 0.0f;
        float chorusOneFilterR = 0.0f;
        sp_butlp_compute(sp, filterL, &chorusOnePShiftL, &chorusOneFilterL);
        sp_butlp_compute(sp, filterR, &chorusOnePShiftR, &chorusOneFilterR);
        
        float finalOutL = chorusOneFilterL * rampedOutputLevel;
        float finalOutR = chorusOneFilterR * rampedOutputLevel;
        
        float mainOutL = 0;
        float mainOutR = 0;
         
        float rampedMix = 0;
        sp_port_compute(sp, mixInternalRamper, &mix, &rampedMix);
        mixL->pos = rampedMix;
        mixR->pos = rampedMix;
         
        sp_crossfade_compute(sp, mixL, &mainInL, &finalOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &finalOutR, &mainOutR);
         
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);
        /*continue;
        
        chorusModOscillator.setFrequency(dFromO * 20.0f);
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
        chorusModOscillator.getSamples(&modLeft, &modRight);
        
        float leftDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * modDepthFraction * modRight;
        chorusDelayLineL.setDelayMs(leftDelayMs);
        chorusDelayLineR.setDelayMs(rightDelayMs);
        chorusOneOutL = chorusDelayLineL.push(chorusOneInL);
        chorusOneOutR = chorusDelayLineR.push(chorusOneInR);
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
        
        float rampedMix = 0;
        sp_port_compute(sp, mixInternalRamper, &mix, &rampedMix);
        mixL->pos = rampedMix;
        mixR->pos = rampedMix;
        
        sp_crossfade_compute(sp, mixL, &mainInL, &chorusFlangeOutL, &mainOutL);
        sp_crossfade_compute(sp, mixR, &mainInR, &chorusFlangeOutR, &mainOutR);
        
        outL[i] = mainOutL;
        outR[i] = mainOutR;
        calculateAmplitudes(mainOutL, mainOutR);*/
    }
};
