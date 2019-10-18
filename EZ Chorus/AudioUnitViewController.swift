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
    @IBAction func xValueSlider(_ sender: UISlider) {
        xValue = Double(sender.value)
    }
    
    @IBAction func yValueSlider(_ sender: UISlider) {
        yValue = Double(sender.value)
    }
    var audioUnit: EZSpacerAU? {
        didSet {
            DispatchQueue.main.async {
                if self.isViewLoaded {
                    self.view.backgroundColor = .black
                    self.audioUnit?.start()
                    //self.audioUnit?.loadFirstPreset()
                }
            }
        }
    }
    
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
    @objc open dynamic var isActive: Double = 1.0 {
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
        print ("hello")
        if audioUnit == nil {
            return
        }
        print ("hello")
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
        
        audioUnit?.xValue = 0.5
        audioUnit?.yValue = 0.5
        audioUnit?.isActive = 1.0
        
        return audioUnit!
    }
    
}
