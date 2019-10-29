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
    
public:
    sp_revsc *reverb;
    sp_crossfade *reverbCrossfadeL;
    sp_crossfade *reverbCrossfadeR;
    
    AudioKitCore::AdjustableDelayLine leftDelayLine, rightDelayLine;
    AudioKitCore::FunctionTableOscillator modOscillator;
    float minDelayMs, maxDelayMs, midDelayMs, delayRangeMs;
    float modFreqHz, modDepthFraction, dryWetMix;
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
    sp_crossfade *crossfadeL;
    sp_crossfade *crossfadeR;
    
    float reverbTime = 0.0f;
    float reverbStrength = 0.0f;
};

#endif /* __cplusplus */

