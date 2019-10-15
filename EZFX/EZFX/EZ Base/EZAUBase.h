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

@property (nonatomic) float xValue;
@property (nonatomic) float yValue;
@property (nonatomic) float isActive;

- (NSArray *)standardParameters;
- (void)setKernelPtr:(void *)ptr;

-(void)setXValue:(float)xValue;
-(void)setYValue:(float)yValue;
-(void)setIsActive:(float)isActive;

@end
