//
//  EZDelayKernel.h
//  AudioKit
//
//  Created by Colin on 02/11/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#ifdef __cplusplus
#pragma once

#include "EZKernelBase.hpp"
#include "AdjustableDelayLine.hpp"
#include "FunctionTable.hpp"
#include "ModulatedDelay_Defines.h"

#include <iostream>

class EZDelayKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZDelayKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
    enum EZDelayAddress {
        delayTypeAddress = amountOfEZAddresses
    };
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void getAndSteps();
    
public:
    
    int delayType = 0;
    
private:

    sp_vdelay *pingPongDelayL;
    sp_vdelay *pinkPongDelayFillIn;
    sp_vdelay *pingPongDelayR;
    
    sp_vdelay *simpleDelayL;
    sp_vdelay *simpleDelayR;
    
    sp_vdelay *reversedDelayL;
    sp_vdelay *reversedDelayR;
    sp_reverse *reverseL;
    sp_reverse *reverseR;
    
};

#endif /* __cplusplus */
