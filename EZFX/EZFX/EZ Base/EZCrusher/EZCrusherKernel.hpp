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
    
public:

    sp_paulstretch *timeStretch;
    sp_ftbl *ft;
    sp_tblrec *tblrec;
};

#endif /* __cplusplus */
