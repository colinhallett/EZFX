//
//  EZCrusherKernel.h
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

class EZCrusherKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZCrusherKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
    enum EZCrusherAddress {
        noiseLevelAddress = amountOfEZAddresses
    };
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void getAndSteps();
    
public:
    float noiseLevel = 0;
    ParameterRamper noiseLevelRamper = 0.0;
    sp_port *noiseLevelInternalRamper;
    
    sp_buthp *outputHpfL;
    sp_buthp *outputHpfR;
    
    sp_saturator *saturatorL;
    sp_saturator *saturatorR;
    
    sp_dist *distL;
    sp_dist *distR;
    
    sp_bitcrush *bitcrushL;
    sp_bitcrush *bitcrushR;
    
    sp_pinknoise *pinkNoise;
    sp_buthp *noiseHpf;
    sp_jitter *randomiser;
    
    sp_compressor *compL;
    sp_compressor *compR;
    
  
    
};

#endif /* __cplusplus */
