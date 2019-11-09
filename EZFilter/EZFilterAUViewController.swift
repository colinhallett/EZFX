//
//  EZFilterAUViewController.swift
//  EZFilter
//
//  Created by Colin on 08/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class EZFilterAUViewController: EZAUViewController {
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZFilterAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
}
