//
//  EZFilterAU.m
//  AudioKit
//
//  Created by Colin on 30/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#import "EZFilterAU.h"
#import "EZFilterKernel.hpp"
#import "BufferedAudioBus.hpp"
#import <AudioKit/AudioKit-Swift.h>

@implementation EZFilterAU {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    EZFilterKernel  _kernel;
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
    
    _lfoModAUParameter = [AUParameterTree createParameterWithIdentifier:@"lfoMod"
                   name:@"LFO Mod"
                address:EZFilterKernel::lfoModAddress
                    min:0.0
                    max:1.0
                   unit:kAudioUnitParameterUnit_Generic
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _lfoRateAUParameter = [AUParameterTree createParameterWithIdentifier:@"lfoRate"
                   name:@"LFO Rate"
                address:EZFilterKernel::lfoRateAddress
                    min:0.0
                    max:80.0
                   unit:kAudioUnitParameterUnit_Hertz
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    _filterTypeAUParameter = [AUParameterTree createParameterWithIdentifier:@"filterType"
                   name:@"Filter Type"
                address:EZFilterKernel::filterTypeAddress
                    min:0
                    max:4
                   unit:kAudioUnitParameterUnit_Indexed
               unitName:nil
                  flags:flags
           valueStrings:nil
    dependentParameters:nil];
    
    _lfoModAUParameter.value = 0.0;
    _kernel.setParameter(EZFilterKernel::lfoModAddress, _lfoModAUParameter.value);
    
    _lfoRateAUParameter.value = 10.0;
    _kernel.setParameter(EZFilterKernel::lfoRateAddress, _lfoModAUParameter.value);
    
    _filterTypeAUParameter.value = 0;
    _kernel.setParameter(EZFilterKernel::filterTypeAddress, _filterTypeAUParameter.value);
    
    
    NSArray *children = [[self standardParameters] arrayByAddingObjectsFromArray:@[_lfoModAUParameter, _lfoRateAUParameter, _filterTypeAUParameter]];
    
    _parameterTree = [AUParameterTree treeWithChildren:children];
    
    EZFilterKernel *blockKernel = &_kernel; \
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

- (void)setLfoRate:(float)filterRate {
    
}
- (void) setLfoMod:(float)filterMod {
    
}
- (void) setFilterType:(float)filterType{
    
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
    __block EZFilterKernel *state = &_kernel;
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

