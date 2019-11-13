//
//  EZAUBase.m
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#import "EZAUBase.h"
#import "EZKernelBase.hpp"

@implementation EZAUBase {
    EZKernelBase *kernelPtr;
}

- (void)setKernelPtr:(void *)ptr {
    kernelPtr = (EZKernelBase *)ptr;
}

- (void)setXValue:(float)xValue {
    kernelPtr->setXValue(xValue);
}
- (void)setYValue:(float)yValue {
    kernelPtr->setYValue(yValue);
}
- (void)setIsActive:(float)isActive {
    kernelPtr->setIsActive(isActive);
}
-(void)setMix:(float)mix {
    kernelPtr->setMix(mix);
}
-(void)setOutputLevel:(float)outputLevel {
    kernelPtr->setOutputLevel(outputLevel);
}

- (float)lowAmplitude {
    return kernelPtr->lowAmplitude;
}

- (float)bp1Amp {
    return kernelPtr->bp1Amp;
}
- (float)bp2Amp {
    return kernelPtr->bp2Amp;
}
- (float)bp3Amp {
    return kernelPtr->bp3Amp;
}
- (float)bp4Amp {
    return kernelPtr->bp4Amp;
}
- (float)bp5Amp {
    return kernelPtr->bp5Amp;
}
- (float)bp6Amp {
    return kernelPtr->bp6Amp;
}
- (float)bp7Amp {
    return kernelPtr->bp7Amp;
}
- (float)bp8Amp {
    return kernelPtr->bp8Amp;
}
- (float)highHighAmplitude {
    return kernelPtr->highCutAmplitude;
}

- (BOOL)isSetUp { return kernelPtr->resetted; }

- (NSArray *)standardParameters {
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable;
    _xValueAUParameter = [AUParameterTree createParameterWithIdentifier:@"xValue"
                       name:@"X Value"
                    address:EZKernelBase::xValueAddress
                        min:-0.5
                        max:0.5
                       unit:kAudioUnitParameterUnit_Generic
                   unitName:nil
                      flags:flags
               valueStrings:nil
        dependentParameters:nil];
    _yValueAUParameter = [AUParameterTree createParameterWithIdentifier:@"yValue"
                   name:@"Y Value"
                address:EZKernelBase::yValueAddress
                    min:-0.5
                    max:0.5
                   unit:kAudioUnitParameterUnit_Generic
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _isActiveAUParameter = [AUParameterTree createParameterWithIdentifier:@"isActive"
                   name:@"Is Active"
                address:EZKernelBase::isActiveAddress
                    min:0.0
                    max:1.0
                   unit:kAudioUnitParameterUnit_Boolean
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _mixAUParameter = [AUParameterTree createParameterWithIdentifier:@"mix"
                   name:@"Mix"
                address:EZKernelBase::mixAddress
                    min:0.0
                    max:1.0
                   unit:kAudioUnitParameterUnit_Generic
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _outputLevelAUParameter = [AUParameterTree createParameterWithIdentifier:@"outputLevel"
                   name:@"Output Level"
                address:EZKernelBase::outputLevelAddress
                    min:-80.0
                    max:20.0
                   unit:kAudioUnitParameterUnit_Decibels
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _inputLevelAUParameter = [AUParameterTree createParameterWithIdentifier:@"inputLevel"
                   name:@"Input Level"
                address:EZKernelBase::inputLevelAddress
                    min:-80.0
                    max:20.0
                   unit:kAudioUnitParameterUnit_Decibels
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    
    _xValueAUParameter.value = 0.0;
    _yValueAUParameter.value = 0.0;
    _isActiveAUParameter.value = 1.0;
    _mixAUParameter.value = 0.75;
    _inputLevelAUParameter.value = 0;
    _outputLevelAUParameter.value = 0;
    
    kernelPtr->setParameter(EZKernelBase::xValueAddress,  _xValueAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::yValueAddress,  _yValueAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::isActiveAddress,  _isActiveAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::mixAddress, _mixAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::inputLevelAddress, _inputLevelAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::outputLevelAddress, _outputLevelAUParameter.value);
    
    return @[_xValueAUParameter,
            _yValueAUParameter,
            _isActiveAUParameter,
            _mixAUParameter,
            _inputLevelAUParameter,
            _outputLevelAUParameter];
    
}

@end
