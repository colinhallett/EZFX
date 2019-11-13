//
//  EZFilterAU.h
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once

#import "EZAUBase.h"

@interface EZFilterAU : EZAUBase

- (void)reset;

@property AUParameter *lfoModAUParameter;
@property AUParameter *lfoRateAUParameter;

@property (nonatomic) float lfoMod;
@property (nonatomic) float lfoRate;

-(void)setLfoMod:(float)filterMod;
-(void)setLfoRate:(float)filterRate;
@end
