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

#include <iostream>

class EZSpacerKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZSpacerKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void initSPAndSetValues();
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
    void resetFX();
    
public:
    sp_zitarev *reverb;
    
    sp_phasor * lfoPhasor;
    float lfoOne = 0;
    
    sp_paulstretch *stretch;
    
    sp_tblrec *tblrec;
    
    sp_ftbl *ftbl;
    UInt32 ftbl_size = 4096;
    
};

#endif /* __cplusplus */
