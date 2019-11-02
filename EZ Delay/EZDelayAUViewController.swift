//
//  AudioUnitViewController.swift
//  EZ Delay
//
//  Created by Colin on 02/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class EZDelayAUViewController: EZAUViewController {
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZDelayAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
}
