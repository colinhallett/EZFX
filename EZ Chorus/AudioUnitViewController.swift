//
//  AudioUnitViewController.swift
//  EZ Chorus
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    
    @IBAction func isActiveSwitch(_ sender: UISwitch) {
        isActive = sender.isOn ? 1 : 0
    }
    var audioUnit: EZSpacerAU?
    
    fileprivate var xValueParameter: AUParameter?
    fileprivate var yValueParameter: AUParameter?
    fileprivate var isActiveParameter: AUParameter?
    
    @objc open dynamic var xValue: Double = 0.0 {
        willSet {
            guard xValue != newValue else { return }
            if audioUnit?.isSetUp == true {
                xValueParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.xValue = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var yValue: Double = 0.0 {
        willSet {
            guard yValue != newValue else { return }
            if audioUnit?.isSetUp == true {
                yValueParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.yValue = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var isActive: Double = 0.0 {
        willSet {
            guard isActive != newValue else { return }
            if audioUnit?.isSetUp == true {
                isActiveParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.isActive = AUValue(newValue)
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioUnit == nil {
            return
        }
        
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    }
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZSpacerAU(componentDescription: componentDescription, options: [])
        
        audioUnit?.xValue = 0.5
        audioUnit?.yValue = 0.5
        audioUnit?.isActive = 1.0
        
        guard let tree = audioUnit?.parameterTree else {return audioUnit!}
        
        xValueParameter = tree["xValue"]
        yValueParameter = tree["yValue"]
        isActiveParameter = tree["isActive"]
        
        return audioUnit!
    }
    
}
