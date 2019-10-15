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

- (NSArray *)standardParameters {
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable;
    
    _xValueAUParameter = [AUParameterTree createParameterWithIdentifier:@"xValue"
                       name:@"X Value"
                    address:EZKernelBase::xValueAddress
                        min:0.0
                        max:1.0
                       unit:kAudioUnitParameterUnit_Generic
                   unitName:nil
                      flags:flags
               valueStrings:nil
        dependentParameters:nil];
    _yValueAUParameter = [AUParameterTree createParameterWithIdentifier:@"yValue"
                   name:@"Y Value"
                address:EZKernelBase::yValueAddress
                    min:0.0
                    max:1.0
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
    
    _xValueAUParameter.value = 0.0;
    _yValueAUParameter.value = 0.0;
    _isActiveAUParameter.value = 0.0;
    
    kernelPtr->setParameter(EZKernelBase::xValueAddress,  _xValueAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::yValueAddress,  _yValueAUParameter.value);
    kernelPtr->setParameter(EZKernelBase::isActiveAddress,  _isActiveAUParameter.value);
    
    return @[_xValueAUParameter,
            _yValueAUParameter,
            _isActiveAUParameter];
    
}

@end
