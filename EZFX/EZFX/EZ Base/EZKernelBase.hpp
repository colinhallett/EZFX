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

static inline float distanceFromOrigin(float xPos, float yPos) {
    return sqrt(pow(xPos, 2) + pow(yPos, 2)) * 1.41;
}
static inline float expValue(float value, float expValue) {
    return powf(2, (powf(value, expValue))) - 1;
}

class EZKernelBase : public AKSoundpipeKernel {
public:
    struct TrackerData;
    std::shared_ptr<TrackerData> trackerData;
 
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
    
    void calculateAmplitudes(float inputL, float inputR);
    
    float computeLP(sp_butlp *filL, sp_butlp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR);
    float computeHP(sp_buthp *filL, sp_buthp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR);
    float computeBP(sp_butbp *filL, sp_butbp *filR, sp_rms *rmsL, sp_rms *rmsR, float inL, float inR);


    
public:
    
    void initBP(sp_butbp **filL, sp_butbp **filR, sp_rms **rmsL, sp_rms **rmsR);
    void initTracker();
    void resetTracker();
    
    sp_port *internalXRamper;
    sp_port *internalYRamper;
    
    void initRamper();
    void resetRamper();
    
    float lowAmplitude = 0.0;
    float bp1Amp = 0.0;
    float bp2Amp = 0.0;
    float bp3Amp = 0.0;
    float bp4Amp = 0.0;
    float bp5Amp = 0.0;
    float bp6Amp = 0.0;
    float bp7Amp = 0.0;
    float bp8Amp = 0.0;
    float highCutAmplitude = 0.0;
};

#endif  // #ifdef __cplusplus
