//
//  EZCrusherAUViewController.swift
//  EZCrusher
//
//  Created by Colin on 08/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit

public class EZCrusherAUViewController: EZAUViewController {
    
    private var noiseLevelParameter: AUParameter?
        
    @IBOutlet weak var noiseLevelKnob: MLKnob!
    
    @objc open dynamic var noiseLevel: Double = 0.0 {
        willSet {
            guard noiseLevel != newValue else { return }
            if audioUnit?.isSetUp == true {
                noiseLevelParameter?.value = AUValue(newValue)
                return
            } else {
                  //audioUnit?.lfoRate = AUValue(newValue)
            }
        }
    }
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZCrusherAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    override func setupParameters() {
        super.setupParameters()
        guard let tree = audioUnit?.parameterTree else {return}
        noiseLevelParameter = tree["noiseLevel"]
    }
    override func setupKnobs() {
        super.setupKnobs()
        noiseLevelKnob.value = Double(noiseLevelParameter?.value ?? 0.0)
        noiseLevelKnob.callback = {value in
            self.noiseLevelParameter?.setValue(AUValue(value), originator:
            self.parameterObserverToken)
       }
       noiseLevelKnob.knobName = "Noise Level"
       noiseLevelKnob.knobNameLogic = {value in
            return String((value * 100).rounded()) + "%"
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
            case strongSelf.isActiveParameter!.address:
                let newValue = Double(value)
                   //strongSelf.isActiveSwitchOutlet.isOn = newValue > 0.5 ? true : false
                strongSelf.toggleFXButton.toggleOn = newValue > 0.5 ? true : false
            case strongSelf.mixParameter!.address:
                let newValue = Float(value)
                strongSelf.mixKnob.value = Double(newValue)
            case strongSelf.inputLevelParameter!.address:
                strongSelf.inputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
            case strongSelf.outputLevelParameter!.address:
                strongSelf.outputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
            case strongSelf.noiseLevelParameter!.address:
                strongSelf.noiseLevelKnob.value = Double(value)
            default:
                   NSLog("address not found")
                }
           }
       })
    }
    
}
