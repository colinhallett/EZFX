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

class EZSpacerKernel : public EZKernelBase, public AKBuffered {
   
public:
    
    EZSpacerKernel();
    
    void init(int channelCount, double sampleRate) override;
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
    
public:
    sp_revsc *reverb;
    sp_crossfade *reverbCrossfadeL;
    sp_crossfade *reverbCrossfadeR;
    
    float reverbTime = 0.0f;
    float reverbStrength = 0.0f;
};

#endif /* __cplusplus */
