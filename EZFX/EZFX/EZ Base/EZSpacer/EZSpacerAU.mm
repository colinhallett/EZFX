//
//  EZSpacerAU.m
//  AudioKit
//
//  Created by Colin on 15/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import "EZSpacerAU.h"
#import "EZSpacerKernel.hpp"
#import "BufferedAudioBus.hpp"
#import <AudioKit/AudioKit-Swift.h>

@implementation EZSpacerAU {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    EZSpacerKernel  _kernel;
    BufferedInputBus _inputBus;
    BufferedOutputBus _outputBusBuffer;
}

@synthesize parameterTree = _parameterTree;

- (void)createParameters {
    self.rampDuration = AKSettings.rampDuration; \
    self.defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:AKSettings.sampleRate \
                                                                        channels:AKSettings.channelCount]; \
    _kernel.init(self.defaultFormat.channelCount, self.defaultFormat.sampleRate); \
    _inputBus.init(self.defaultFormat, 8); \
    self.inputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self \
                                                                busType:AUAudioUnitBusTypeInput \
                                                                 busses:@[_inputBus.bus]];
    _outputBusBuffer.init(self.defaultFormat, 2); \
    self.outputBus = _outputBusBuffer.bus; \
    self.outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self \
                                                                busType:AUAudioUnitBusTypeOutput \
                                                                 busses:@[self.outputBus]];
    [self setKernelPtr:&_kernel];
    
    NSArray *children = [self standardParameters];
    _parameterTree = [AUParameterTree treeWithChildren:children];
    
    EZSpacerKernel *blockKernel = &_kernel; \
    self.parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) { \
        blockKernel->setParameter(param.address, value); \
    }; \
    self.parameterTree.implementorValueProvider = ^(AUParameter *param) { \
        return blockKernel->getParameter(param.address); \
    };
    
}

- (void) reset {
    _kernel.reset();
}

- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    if (![super allocateRenderResourcesAndReturnError:outError]) {
        return NO;
    }
    _inputBus.allocateRenderResources(self.maximumFramesToRender);
    _kernel.init(self.outputBus.format.channelCount, self.outputBus.format.sampleRate);
    _kernel.reset();
    return YES;
}

- (void)deallocateRenderResources {
    _inputBus.deallocateRenderResources();
    [super deallocateRenderResources];
}

- (AUInternalRenderBlock)internalRenderBlock {
    __block EZSpacerKernel *state = &_kernel;
    __block BufferedInputBus *input = &_inputBus;
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags,
                          const AudioTimeStamp       *timestamp,
                          AVAudioFrameCount           frameCount,
                          NSInteger                   outputBusNumber,
                          AudioBufferList            *outputData,
                          const AURenderEvent        *realtimeEventListHead,
                          AURenderPullInputBlock      pullInputBlock) {

    AudioUnitRenderActionFlags pullFlags = 0;

    AUAudioUnitStatus err = input->pullInput(&pullFlags, timestamp, frameCount, 0, pullInputBlock);

    if (err != 0) { return err; }

    AudioBufferList *inAudioBufferList = input->mutableAudioBufferList;
        
    AudioBufferList *outAudioBufferList = outputData;
    if (outAudioBufferList->mBuffers[0].mData == nullptr) {
        for (UInt32 i = 0; i < outAudioBufferList->mNumberBuffers; ++i) {
            outAudioBufferList->mBuffers[i].mData = inAudioBufferList->mBuffers[i].mData;
        }
    }

    state->setBuffers(inAudioBufferList, outAudioBufferList);
    state->processWithEvents(timestamp, frameCount, realtimeEventListHead);

    return noErr;
    };
}

@end
