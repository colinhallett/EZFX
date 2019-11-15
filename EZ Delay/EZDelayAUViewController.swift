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
    
    private var delayTypeParameter: AUParameter?
     
    @IBOutlet weak var delaySelection: EZSelector!
    
    @objc open dynamic var delayType: Int = 1 {
        willSet {
            guard delayType != newValue else { return }
            if audioUnit?.isSetUp == true {
                delayTypeParameter?.value = AUValue(newValue)
                return
            } else {
                //audioUnit?.lfoRate = AUValue(newValue)
            }
        }
    }
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZDelayAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
    override func setupParameters() {
        super.setupParameters()
        guard let tree = audioUnit?.parameterTree else {return}
        delayTypeParameter = tree["delayType"]
    }
    override func setupKnobs() {
        super.setupKnobs()
        delaySelection.selectionNames = ["Simple", "Pingpong", "Reverse"]
        delaySelection.callback = {value in self.delayTypeParameter?.setValue(AUValue(value), originator: self.parameterObserverToken)
        }
        
    }
    
    override func setupParamterObservationToken() {
         guard let paramTree = audioUnit?.parameterTree else {
                  NSLog("The audio unit has no parameters!")
                  return
               }
               
        parameterObserverToken =     paramTree.token(byAddingParameterObserver: { [weak self] address, value in
              guard let strongSelf = self else {
                  NSLog("self is nil; returning")
                  return
              }
            
        DispatchQueue.main.async {
            switch address {
            case strongSelf.xValueParameter!.address:
                let newValue = Double(value) + 0.5
                strongSelf.xyPad.updateXPoint(newX: newValue)
                   //set xypad value
            case strongSelf.yValueParameter!.address:
                let newValue = 1 - (Double(value) + 0.5)
                strongSelf.xyPad.updateYPoint(newY: newValue)
            case strongSelf.mixParameter!.address:
                let newValue = Float(value)
                strongSelf.mixKnob.value = Double(newValue)
            case strongSelf.inputLevelParameter!.address:
                strongSelf.inputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
            case strongSelf.outputLevelParameter!.address:
                strongSelf.outputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
            case strongSelf.delayTypeParameter!.address:
                strongSelf.delaySelection.currentSelection = Int(value)
            default:
                   NSLog("address not found")
                }
           }
       })
    }
    
}
