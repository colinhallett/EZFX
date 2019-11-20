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
    
    getAndStep();
    
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
        
        //input hpf
        float hpfOutL, hpfOutR;
        
        sp_buthp_compute(sp, inputHPFL, &inputSaturatorOutL, &hpfOutL);
        sp_buthp_compute(sp, inputHPFR, &inputSaturatorOutR, &hpfOutR);
        
        
       // float xPos = rampedXValue - 0.5;
       // float yPos = rampedYValue - 0.5;
       // float dFromO = distanceFromOrigin(xPos, yPos);//sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
        
        //chorus
        chorusModOscillator.setFrequency(rampedYValue * 10.0f + 0.0001);
        chorusModDepthFraction = rampedXValue * 0.2 + 0.001;
        float chorusOutL, chorusOutR;
        
        float chorusOneInL = hpfOutL;
        float chorusOneInR = hpfOutR;
        
        float modLeft, modRight;
        chorusModOscillator.getSamples(&modLeft, &modRight);
       
        float leftDelayMs = midDelayMs + delayRangeMs * chorusModDepthFraction * modLeft;
        float rightDelayMs = midDelayMs + delayRangeMs * chorusModDepthFraction * modRight;
        chorusDelayLineL.setDelayMs(leftDelayMs);
        chorusDelayLineR.setDelayMs(rightDelayMs);
        chorusOutL = chorusDelayLineL.push(chorusOneInL);
        chorusOutR = chorusDelayLineR.push(chorusOneInR);
        
        //phase
        float phaseOutL, phaseOutR;
        
       // *phaser->depth = rampedYValue;//dFromO * 0.8 + 0.1;
        //*phaser->feedback_gain = rampedXValue * 0.8 + 0.1;
       // *phaser->NotchFreq = 1.2 + 3.6 * rampedYValue;
       // *phaser->Notch_width = 100 + 489 * rampedXValue;
         *phaser->MaxNotch1Freq = 2000 + 8000 * rampedYValue;
        //*phaser->MinNotch1Freq = 1000 + 2000 * dFromO;
        *phaser->lfobpm = 1 + 30 * rampedXValue;
        sp_phaser_compute(sp, phaser, &hpfOutL, &hpfOutR, &phaseOutL, &phaseOutR);
       
        //flange
        float flangeOutL, flangeOutR;
        float flangeL, flangeR;
        
        float flangeFeedback = 0.95 - 1.9 * rampedXValue;
        
        flangeOscillator.setFrequency(rampedYValue * 9.9 + 0.1);
        leftFlangeLine.setFeedback(flangeFeedback);
        rightFlangeLine.setFeedback(flangeFeedback);
        
        //flangeModDepthFraction = rampedYValue;

        
       flangeOscillator.getSamples(&flangeL, &flangeR);
       
       float leftFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeL;
       float rightFlangeMs = midFlangeMs + flangeRangeMs * flangeModDepthFraction * flangeR;
       
       leftFlangeLine.setDelayMs(leftFlangeMs);
       rightFlangeLine.setDelayMs(rightFlangeMs);
       flangeOutL = leftFlangeLine.push(hpfOutL);
       flangeOutR = rightFlangeLine.push(hpfOutR);
       
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
            default:
                fxOutL = 0;
                fxOutR = 0;
        }
        
        //after switch
       /* float delayFDB = 0.6 * rampedYValue;
        delayL->time = 0.02 * rampedXValue;
        delayR->time = 0.04 - 0.04 * rampedXValue;
        delayL->feedback = delayFDB;
        delayR->feedback = delayFDB;
        float filterFreq = 7000; // dFromO + 5000;
        filterL->freq = filterFreq;
        filterR->freq = filterFreq;*/
        
        float widenAmount;
        sp_port_compute(sp, internalWidenRamper, &widen, &widenAmount);
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
        
        float afterCrossfadeOutL, afterCrossfadeOutR;
        
        afterFXCrossfadeL->pos = widenAmount * 0.75;
        afterFXCrossfadeR->pos = widenAmount * 0.75;
        
        sp_crossfade_compute(sp, afterFXCrossfadeL, &fxOutL, &chorusOneFilterL, &afterCrossfadeOutL);
        sp_crossfade_compute(sp, afterFXCrossfadeR, &fxOutR, &chorusOneFilterR, &afterCrossfadeOutR);
        
        float finalOutL = afterCrossfadeOutL * rampedOutputLevel;
        float finalOutR = afterCrossfadeOutR * rampedOutputLevel;
        
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
