//
//  AudioUnitViewController.swift
//  EZ Chorus
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class EZChorusAUViewController: EZAUViewController {
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZChorusAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        
        return audioUnit!
    }
    
}

