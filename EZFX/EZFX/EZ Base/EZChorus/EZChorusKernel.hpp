//
//  EZChorusKernel.h
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#ifdef __cplusplus
#pragma once

#include "EZKernelBase.hpp"
#include "AdjustableDelayLine.hpp"
#include "FunctionTable.hpp"
#include "ModulatedDelay_Defines.h"

#include <iostream>

class EZChorusKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZChorusKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
    void getAndStep(); 
    
    enum EZChorusAddress {
        modulationTypeAddress = amountOfEZAddresses,
        widenAddress = amountOfEZAddresses + 1
    };
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    
public:
    
    int modulationType = 0;
    
    sp_buthp *inputHPFL;
    sp_buthp *inputHPFR;
    
    AudioKitCore::AdjustableDelayLine chorusDelayLineL, chorusDelayLineR;
    AudioKitCore::FunctionTableOscillator chorusModOscillator;
    float minDelayMs, maxDelayMs, midDelayMs, delayRangeMs;
    float chorusModFreqHz, chorusModDepthFraction, chorusDryWetMix;
    sp_delay *delayL;
    sp_delay *delayR;
    sp_pshift *pshiftL;
    sp_pshift *pshiftR;
    sp_butlp *filterL;
    sp_butlp *filterR;
    AudioKitCore::AdjustableDelayLine leftFlangeLine, rightFlangeLine;
    AudioKitCore::FunctionTableOscillator flangeOscillator;
    float minFlangeMs, maxFlangeMs, midFlangeMs, flangeRangeMs;
    float flangeModFreqHz, flangeModDepthFraction, flangeDryWetMix;
    sp_phaser *phaser;
    
    
    float widen = 0.0f;
    ParameterRamper widenRamper = 0.0f;
    sp_port *internalWidenRamper;
    sp_crossfade *afterFXCrossfadeL;
    sp_crossfade *afterFXCrossfadeR;
};

#endif /* __cplusplus */

