//
//  AudioUnitViewController.swift
//  EZ Spacer
//
//  Created by Colin on 29/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class EZSpacerAUViewController: EZAUViewController {
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZSpacerAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
}
