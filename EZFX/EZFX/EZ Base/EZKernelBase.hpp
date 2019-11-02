//
//  EZKernelBase.hpp
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#ifdef __cplusplus
#pragma once

#import "AKSoundpipeKernel.hpp"
#import "AKDSPKernel.hpp"

static float distanceFromOrigin(float xPos, float yPos) {
    return sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
}

class EZKernelBase : public AKSoundpipeKernel {
private:
    
 
public:

    float xValue = 0.0;
    float yValue = 0.0;
    float mix = 1.0;
    float isActive = 1.0;
    
    bool resetted = false; 
    bool fxResetted = false;
    
    ParameterRamper xValueRamper = 0.0;
    ParameterRamper yValueRamper = 0.0;
    ParameterRamper isActiveRamper = 1.0;
    ParameterRamper mixRamper = 1.0;
    
    sp_crossfade *mixL;
    sp_crossfade *mixR;
    
    enum EZAddresses {
        xValueAddress, yValueAddress, isActiveAddress, mixAddress
    };
    
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void standardEZFXGetAndSteps();
    
    void init(int channelCount, double sampleRate) override;
    
    virtual void reset();
    
    void resetCrossfade();
    
    void initCrossfade();
    
    void setXValue(float value);
    void setYValue(float value);
    void setIsActive(float value);
    void setMix(float value);
    
public:
    float leftAmplitude = 0.0;
    float rightAmplitude = 0.0;
    sp_rms *leftRMS;
    sp_rms *rightRMS;
    
    void initTracker();
    void resetTracker();
    
    sp_port *internalXRamper;
    sp_port *internalYRamper;
    
    void initRamper();
    void resetRamper();
};

#endif  // #ifdef __cplusplus
