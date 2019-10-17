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

class EZKernelBase : public AKSoundpipeKernel {
private:
    
 
public:

    float xValue = 0.0;
    float yValue = 0.0;
    float isActive = 0.0;
    
    ParameterRamper xValueRamper = 0.0;
    ParameterRamper yValueRamper = 0.0;
    ParameterRamper isActiveRamper = 0.0;
    
    enum EZAddresses {
        xValueAddress, yValueAddress, isActiveAddress
    };
    
    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value);

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override;
    
    void standardEZFXGetAndSteps();
    
    void init(int channelCount, double sampleRate) override;
    
    virtual void reset();
    
    void setXValue(float value);
    void setYValue(float value);
    void setIsActive(float value);
};

#endif  // #ifdef __cplusplus
