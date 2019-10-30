//
//  EZFilterKernel.h
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#ifdef __cplusplus
#pragma once

#include "EZKernelBase.hpp"
#include "AdjustableDelayLine.hpp"
#include "FunctionTable.hpp"
#include "ModulatedDelay_Defines.h"

#include <iostream>

class EZFilterKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZFilterKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
public:
    sp_phasor * lfoPhasor;
    float lfoOne = 0;
    
    sp_moogladder *filterL;
    sp_moogladder *filterR;
};

#endif /* __cplusplus */
