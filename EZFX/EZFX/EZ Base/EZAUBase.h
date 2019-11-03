//
//  EZAUBase.h
//  EZFX
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

#pragma once

#import "AKAudioUnit.h"

@interface EZAUBase : AKAudioUnit

@property AUParameter *xValueAUParameter;
@property AUParameter *yValueAUParameter;
@property AUParameter *isActiveAUParameter;
@property AUParameter *mixAUParameter;

@property (nonatomic) float xValue;
@property (nonatomic) float yValue;
@property (nonatomic) float isActive;
@property (nonatomic) float mix;
@property (readonly) float lowAmplitude;
@property (readonly) float lowMidAmplitude;
@property (readonly) float highMidAmplitude;
@property (readonly) float lowHighAmplitude;
@property (readonly) float highHighAmplitude;

- (NSArray *)standardParameters;
- (void)setKernelPtr:(void *)ptr;

-(void)setXValue:(float)xValue;
-(void)setYValue:(float)yValue;
-(void)setIsActive:(float)isActive;
-(void)setMix:(float)mix;

@end
