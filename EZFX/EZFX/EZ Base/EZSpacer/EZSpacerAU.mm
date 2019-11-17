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
    _kernel.init(self.defaultFormat.channelCount, self.defaultFormat.sampleRate);
    _inputBus.init(self.defaultFormat, 8);
    
    self.inputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeInput busses:@[_inputBus.bus]];
    
    _outputBusBuffer.init(self.defaultFormat, 2);
    self.outputBus = _outputBusBuffer.bus;
    self.outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self
        busType:AUAudioUnitBusTypeOutput
        busses:@[self.outputBus]];
    
    [self setKernelPtr:&_kernel];
    
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable;
    
    _predelayParameter = [AUParameterTree createParameterWithIdentifier:@"predelay"
                   name:@"Predelay Time"
                address:EZSpacerKernel::predelayAddress
                    min:0.0
                    max:730.0
                   unit:kAudioUnitParameterUnit_Milliseconds
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    
    _predelayParameter.value = 0.0;
    _kernel.setParameter(EZSpacerKernel::predelayAddress, _predelayParameter.value);
    
    NSArray *children = [[self standardParameters]
            arrayByAddingObjectsFromArray:@[_predelayParameter]];
    
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
   _outputBusBuffer.allocateRenderResources(self.maximumFramesToRender); \
    
    _kernel.init(self.outputBus.format.channelCount, self.outputBus.format.sampleRate); \
    _kernel.reset();
       return YES;
    
}

- (void)deallocateRenderResources {
    _inputBus.deallocateRenderResources();
    _outputBusBuffer.deallocateRenderResources();
    [super deallocateRenderResources];
}

- (BOOL)canProcessInPlace {
    return NO;
}

- (AUInternalRenderBlock)internalRenderBlock {
    __block EZSpacerKernel *state = &_kernel;
    __block BufferedInputBus *input = &_inputBus;
    
    return ^AUAudioUnitStatus(
            AudioUnitRenderActionFlags *actionFlags,
            const AudioTimeStamp       *timestamp,
            AVAudioFrameCount          frameCount,
            NSInteger                outputBusNumber,
            AudioBufferList           *outputData,
            const AURenderEvent   *realtimeEventListHead,
            AURenderPullInputBlock    pullInputBlock) {
        
        _outputBusBuffer.prepareOutputBufferList(outputData, frameCount, true);
        AudioBufferList *inAudioBufferList = input->mutableAudioBufferList;
        pullInputBlock(actionFlags, timestamp, frameCount, 0, inAudioBufferList);
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
