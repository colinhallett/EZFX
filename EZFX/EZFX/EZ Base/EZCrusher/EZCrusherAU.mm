//
//  EZCrusherAU.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import "EZCrusherAU.h"
#import "EZCrusherKernel.hpp"
#import "BufferedAudioBus.hpp"
#import <AudioKit/AudioKit-Swift.h>

@implementation EZCrusherAU {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    EZCrusherKernel  _kernel;
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
    
    _noiseLevelParameter = [AUParameterTree createParameterWithIdentifier:@"noiseLevel"
                   name:@"Noise Level"
                address:EZCrusherKernel::noiseLevelAddress
                    min:0.0
                    max:1.0
                   unit:kAudioUnitParameterUnit_Percent
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _distTypeParameter = [AUParameterTree createParameterWithIdentifier:@"distType"
                   name:@"Crush Type"
                address:EZCrusherKernel::distTypeAddress
                    min:0
                    max:3
                   unit:kAudioUnitParameterUnit_Indexed
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    
    _noiseLevelParameter.value = 0.0;
    _kernel.setParameter(EZCrusherKernel::noiseLevelAddress, _noiseLevelParameter.value);
    
     _distTypeParameter.value = 0.0;
    _kernel.setParameter(EZCrusherKernel::distTypeAddress, _distTypeParameter.value);
    
    NSArray *children = [[self standardParameters] arrayByAddingObjectsFromArray:@[_noiseLevelParameter, _distTypeParameter]];
    
    _parameterTree = [AUParameterTree treeWithChildren:children];
    
    EZCrusherKernel *blockKernel = &_kernel; \
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
    __block EZCrusherKernel *state = &_kernel;
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
