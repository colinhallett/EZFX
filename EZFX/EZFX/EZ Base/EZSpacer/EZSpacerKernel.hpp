//
//  EZSpacerKernel.hpp
//  AudioKit
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#ifdef __cplusplus
#pragma once

#include "EZKernelBase.hpp"
#include "AdjustableDelayLine.hpp"
#include "FunctionTable.hpp"
#include "ModulatedDelay_Defines.h"


#include "AKVariableDelayDSP.hpp"
#import "AKLinearParameterRamp.hpp"

#include <iostream>

class EZSpacerKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZSpacerKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
     enum EZSpacerAddress {
            predelayAddress = amountOfEZAddresses,
            brightnessAddress = amountOfEZAddresses + 1
        };
    
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void getAndSteps();
        
public:
        
    float predelay = 0;
    ParameterRamper predelayRamper = 0.0;
    sp_port *predelayInternalRamper;
    
    float brightness = 0;
    ParameterRamper brightnessRamper = 0.0;
    sp_port *brightnessInternalRamper;
    
    sp_zitarev *reverb;
    
    sp_panst *stereoPan; 
    
    sp_phasor * lfoPhasor;
    float lfoOne = 0;
    
    sp_vdelay *vDelayL;
    sp_vdelay *vDelayR;
};

#endif /* __cplusplus */
