//
//  EZCrusherAU.h
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once

#import "EZAUBase.h"

@interface EZCrusherAU : EZAUBase

- (void)reset;
@property AUParameter *noiseLevelParameter;

@property (nonatomic) float noiseLevel;

-(void)setNoiseLevel:(float)noiseLevel;

@end
