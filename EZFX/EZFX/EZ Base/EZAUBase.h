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
@property (readonly) float bp1Amp;
@property (readonly) float bp2Amp;
@property (readonly) float bp3Amp;
@property (readonly) float bp4Amp;
@property (readonly) float bp5Amp;
@property (readonly) float bp6Amp;
@property (readonly) float bp7Amp;
@property (readonly) float bp8Amp;
@property (readonly) float highHighAmplitude;

- (NSArray *)standardParameters;
- (void)setKernelPtr:(void *)ptr;

-(void)setXValue:(float)xValue;
-(void)setYValue:(float)yValue;
-(void)setIsActive:(float)isActive;
-(void)setMix:(float)mix;

@end
