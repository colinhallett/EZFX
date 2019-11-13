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
    
    
    private var lfoRateParameter: AUParameter?
    private var lfoModParameter: AUParameter?
     
    @IBOutlet weak var lfoRateKnob: MLKnob!
    @IBOutlet weak var lfoModKnob: MLKnob!
       
   @objc open dynamic var lfoRate: Double = 1.0 {
       willSet {
           guard lfoRate != newValue else { return }
           if audioUnit?.isSetUp == true {
               lfoRateParameter?.value = AUValue(newValue)
               return
           } else {
               //audioUnit?.lfoRate = AUValue(newValue)
           }
       }
   }
    
    @objc open dynamic var lfoMod: Double = 1.0 {
        willSet {
            guard lfoMod != newValue else { return }
            if audioUnit?.isSetUp == true {
                lfoModParameter?.value = AUValue(newValue)
                return
            } else {
                //audioUnit?.lfoRate = AUValue(newValue)
            }
        }
    }
    
    public override func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try EZFilterAU(componentDescription: componentDescription, options: [])
        
        setupParameters()
        return audioUnit!
    }
    
    override func setupParameters() {
        super.setupParameters()
        guard let tree = audioUnit?.parameterTree else {return}
        lfoModParameter = tree["lfoMod"]
        lfoRateParameter = tree["lfoRate"]
    }
    override func setupKnobs() {
        super.setupKnobs()
        let lfoRateValue = convertToRange(number: Double(lfoRateParameter?.value ?? 0.0), inputRange: 0..<80.0, outputRange: 0..<1.0)
        lfoRateKnob.value = lfoRateValue
        lfoRateKnob.callback = {value in
            let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: 0..<80.0)
            self.lfoRateParameter?.setValue(AUValue(newValue), originator:
            self.parameterObserverToken)
       }
       lfoRateKnob.knobName = "LFO Rate"
       lfoRateKnob.knobNameLogic = {value in
        let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: 0..<80.0)
            return String((newValue * 10000).rounded() / 10000) + "Hz"
        }
        lfoRateKnob.knobSensitivity = 0.0005
        
        lfoModKnob.value = Double(lfoModParameter?.value ?? 0.0)
        lfoModKnob.callback = {value in
            self.lfoModParameter?.setValue(AUValue(value), originator:
            self.parameterObserverToken)
        }
        lfoModKnob.knobName = "LFO Mod"
        lfoModKnob.knobNameLogic = {value in
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
            case strongSelf.lfoModParameter!.address:
                strongSelf.lfoModKnob.value = Double(value)
            case strongSelf.lfoRateParameter!.address:
               strongSelf.lfoRateKnob.value = convertToRange(number: Double(value), inputRange: 0..<80.0, outputRange: 0..<1.0)
            default:
                   NSLog("address not found")
                }
           }
       })
    }
    
}
