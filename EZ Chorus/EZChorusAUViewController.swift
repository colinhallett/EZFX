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
    
    private var modulationTypeParameter: AUParameter?
       
    @IBOutlet weak var modulationSelector: EZSelector!
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZChorusAU(componentDescription: componentDescription, options: [.loadOutOfProcess])
        
        setupParameters()
        
        return audioUnit!
    }
    
    override func setupParameters() {
        super.setupParameters()
        guard let tree = audioUnit?.parameterTree else {return}
        modulationTypeParameter = tree["modulationType"]
    }
    
    override func setupKnobs() {
        super.setupKnobs()
        modulationSelector.selectionNames = ["Chorus", "Phaser", "Flanger", "Panner"]
        modulationSelector.callback = {value in self.modulationTypeParameter?.setValue(AUValue(value), originator: self.parameterObserverToken)
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
            case strongSelf.modulationTypeParameter!.address:
                strongSelf.modulationSelector.currentSelection = Int(value)
            default:
                   NSLog("address not found")
                }
           }
       })
    }
    
}

