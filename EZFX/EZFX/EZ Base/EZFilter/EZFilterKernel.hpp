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
    
    enum EZFilterAddress {
        lfoModAddress = amountOfEZAddresses,
        lfoRateAddress = amountOfEZAddresses + 1,
        filterTypeAddress = amountOfEZAddresses + 2
    };
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void getAndSteps();
    
public:
    float lfoMod = 0;
    float lfoRate = 0;
    
    ParameterRamper lfoModRamper = 0.0;
    ParameterRamper lfoRateRamper = 0.0;
    
    sp_port *lfoModInternalRamper;
    sp_port *lfoRateInternalRamper;
    
    int filterType = 0;
    
    sp_phasor * lfoPhasor;
    float lfoOne = 0;
    
    sp_moogladder *lpfL;
    sp_moogladder *lpfR;
    
    sp_reson *bwL;
    sp_reson *bwR;
    
    sp_buthp *hpfL;
    sp_buthp *hpfR;
    
    sp_streson *stringL;
    sp_streson *stringR;
    
    sp_tbvcf *lpf303L;
    sp_tbvcf *lpf303R;
    
    sp_wpkorg35 *lpf35L;
    sp_wpkorg35 *lpf35R;
};

#endif /* __cplusplus */
