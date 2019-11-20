//
//  EZChorusAU.m
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once

#import "EZAUBase.h"

@interface EZChorusAU : EZAUBase

- (void)reset;

@property AUParameter *modulationTypeParameter;
@property AUParameter *widenParameter;

@end
