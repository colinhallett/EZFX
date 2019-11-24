//
//  EZSpacerAU.h
//  AudioKit For iOS
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once

#import "EZAUBase.h"

@interface EZSpacerAU : EZAUBase

@property AUParameter *predelayParameter;
@property AUParameter *brightnessParameter;

- (void)reset;

@end
