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
    
    private var predelayParameter: AUParameter?
    private var brightnessParameter: AUParameter?
    
    @IBOutlet weak var predelayKnob: MLKnob!
    @IBOutlet weak var brightnessKnob: MLKnob!
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZSpacerAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
    override func setupParameters() {
        super.setupParameters()
        guard let tree = audioUnit?.parameterTree else {return}
        predelayParameter = tree["predelay"]
        brightnessParameter = tree["brightness"]
    }
    
    override func setupKnobs() {
        super.setupKnobs()
        
        let predelayValue = convertToRange(number: Double(predelayParameter?.value ?? 0.0), inputRange: 0..<730.0, outputRange: 0..<1.0)
        predelayKnob.value = predelayValue
        predelayKnob.callback = {value in
            let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: 0..<730.0)
            self.predelayParameter?.setValue(AUValue(newValue), originator:
            self.parameterObserverToken)
       }
       predelayKnob.knobName = "Predelay Time"
       predelayKnob.knobNameLogic = {value in
        let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: 0..<730.0)
        return String(newValue.rounded()) + "ms"
        }
        
        brightnessKnob.value = Double(brightnessParameter?.value ?? 0.0)
        brightnessKnob.callback = {value in
            self.brightnessParameter?.setValue(AUValue(value), originator:  self.parameterObserverToken)
        }
        brightnessKnob.knobName = "Colour"
        brightnessKnob.knobNameLogic = {value in
            return String(Int(value * 100)) + "%"
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
            case strongSelf.predelayParameter!.address:
                strongSelf.predelayKnob.value = convertToRange(number: Double(value), inputRange: 0..<730.0, outputRange: 0..<1.0)
            case strongSelf.brightnessParameter!.address:
                let newValue = Float(value)
                strongSelf.brightnessKnob.value = Double(newValue)
            default:
                   NSLog("address not found")
                }
           }
       })
    }
    
}
