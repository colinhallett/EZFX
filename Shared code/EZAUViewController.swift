//
//  AudioUnitViewController.swift
//  EZ Chorus
//
//  Created by Colin on 14/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import CoreAudioKit
import AudioKit
public class EZAUViewController: AUViewController, AUAudioUnitFactory {
    
    public func createAudioUnit(with desc: AudioComponentDescription) throws -> AUAudioUnit {
        return audioUnit!
    }
    
    @IBOutlet weak var xyPad: XYPadView!
    
    @IBOutlet weak var mixKnob: MLKnob!
    @IBOutlet weak var inputLevelKnob: MLKnob!
    @IBOutlet weak var outputLevelKnob: MLKnob!
    @IBOutlet weak var toggleFXButton: ToggleButton!
    @IBOutlet weak var toggleLoopButton: ToggleButton!
    
    @IBOutlet weak var lowLevel: UILabel!
    @IBOutlet weak var bp1Level: UILabel!
    @IBOutlet weak var bp2Level: UILabel!
    @IBOutlet weak var bp3Level: UILabel!
    @IBOutlet weak var bp4Level: UILabel!
    @IBOutlet weak var bp5Level: UILabel!
    @IBOutlet weak var bp6Level: UILabel!
    @IBOutlet weak var bp7Level: UILabel!
    @IBOutlet weak var bp8Level: UILabel!
    @IBOutlet weak var highLevel: UILabel!
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //xyPad.setupPadArea()
    }
    
    var audioUnit: EZAUBase? {
        didSet {
            DispatchQueue.main.async {
                if self.isViewLoaded {
                    self.view.backgroundColor = .black
                    self.connectUIToAudioUnit()
                }
            }
        }
    }
    
    var xValueParameter: AUParameter?
    var yValueParameter: AUParameter?
    var isActiveParameter: AUParameter?
    var mixParameter: AUParameter?
    var inputLevelParameter: AUParameter?
    var outputLevelParameter: AUParameter?
    
    var parameterObserverToken: AUParameterObserverToken?
    
    @objc open dynamic var mixValue: Double = 1.0 {
        willSet {
            guard mixValue != newValue else { return }
            if audioUnit?.isSetUp == true {
                mixParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.mix = AUValue(newValue)
            }
        }
    }
    
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
    @objc open dynamic var inputLevel: Double = 0.8 {
        willSet {
            guard inputLevel != newValue else { return }
            if audioUnit?.isSetUp == true {
                inputLevelParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.inputLevel = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var outputLevel: Double = 0.8 {
        willSet {
            guard outputLevel != newValue else { return }
            if audioUnit?.isSetUp == true {
                outputLevelParameter?.value = AUValue(newValue)
                return
            } else {
                audioUnit?.outputLevel = AUValue(newValue)
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        xyPad.delegate = self
        if audioUnit == nil {
            return
        }
        connectUIToAudioUnit()
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    }
    
    func setupParameters () {
       
        guard let tree = audioUnit?.parameterTree else {return}
      
        xValueParameter = tree["xValue"]
        yValueParameter = tree["yValue"]
        isActiveParameter = tree["isActive"]
        mixParameter = tree["mix"]
        inputLevelParameter = tree["inputLevel"]
        outputLevelParameter = tree["outputLevel"]
        
        audioUnit?.rampDuration = 0.00001
    }
    
    func setupKnobs() {
        mixKnob.value = Double(mixParameter?.value ?? 0.0)
        mixKnob.callback = {value in
            self.mixParameter?.setValue(AUValue(value), originator: self.parameterObserverToken)
        }
        mixKnob.knobName = "Mix"
        mixKnob.knobNameLogic = {value in
            return String((value * 100).rounded()) + "%"
        }
        
        let newOutputLevel = convertToRange(number: Double(outputLevelParameter?.value ?? 0.0), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
        outputLevelKnob.value = newOutputLevel
        outputLevelKnob.callback = {value in
            let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: -80.0..<20.0)
            self.outputLevelParameter?.setValue(AUValue(newValue), originator: self.parameterObserverToken)
        }
        outputLevelKnob.knobName = "Output Gain"
        outputLevelKnob.knobNameLogic = {value in
            let newValue = (convertToRange(number: value, inputRange: 0..<1.0, outputRange: -80.0..<20.0) * 100).rounded() / 100
            
            return String(newValue) + " dB"
        }
        
        let newInputLevel = convertToRange(number: Double(inputLevelParameter?.value ?? 0.0), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
        inputLevelKnob.value = newInputLevel
        inputLevelKnob.callback = {value in
            let newValue = convertToRange(number: value, inputRange: 0..<1.0, outputRange: -80.0..<20.0)
            self.inputLevelParameter?.setValue(AUValue(newValue), originator: self.parameterObserverToken)
        }
        inputLevelKnob.knobName = "Input Gain"
        inputLevelKnob.knobNameLogic = {value in
            let newValue = (convertToRange(number: value, inputRange: 0..<1.0, outputRange: -80.0..<20.0) * 100).rounded() / 100
            
            return String(newValue) + " dB"
        }
        
        toggleLoopButton.callback = {toggle in
            self.xyPad.isLooping = toggle
        }
        toggleFXButton.toggleOn = isActiveParameter?.value ?? 1.0 > 0.5 ? true : false
        toggleFXButton.callback = {toggle in
            self.isActiveParameter?.setValue(toggle ? 1 : 0, originator: self.parameterObserverToken)
        }
        
        let newXValue = Double(xValueParameter?.value ?? 0) + 0.5
        xyPad.updateXPoint(newX: newXValue)
        let newYValue = Double(yValueParameter?.value ?? 0) + 0.5
        xyPad.updateYPoint(newY: newYValue)
    }
    
    func setupParamterObservationToken() {
        
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
                       // strongSelf.mixSliderOutlet.setValue(newValue, animated: true)
                    //set slider
                    case strongSelf.inputLevelParameter!.address:
                        strongSelf.inputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
                    case strongSelf.outputLevelParameter!.address:
                        strongSelf.outputLevelKnob.value = convertToRange(number: Double(value), inputRange: -80.0..<20.0, outputRange: 0..<1.0)
                   default:
                        NSLog("address not found")
                }
            }
        })
    }

    func connectUIToAudioUnit() {
        setupParamterObservationToken()
        setupKnobs()
        setDefaults()
    }
    
    func setDefaults() {
        
    }

}


extension EZAUViewController : XYPadDelegate {
    func setXValue(value: Double) {
        let newValue = value - 0.5
        xValueParameter?.setValue(AUValue(newValue), originator: parameterObserverToken)
    }
    func setYValue(value: Double) {
        let newValue = ((1 - value) - 0.5)
        yValueParameter?.setValue(AUValue(newValue), originator: parameterObserverToken)
    }
    
    func checkThreshold(input: Float, threshold: Float) -> Float {
        return input < threshold ? 0 : input //(input > threshold ? input : (input < 0.01 ? 0 : input))
    }
    func dLinkCallback() {
        guard let audioUnit = audioUnit else {return}
        let scaleFactor: Float = 20
        let threshold: Float = 0.001
        
        let bp1Amp = checkThreshold(input: audioUnit.bp1Amp * scaleFactor, threshold: threshold)
        let bp4Amp = checkThreshold(input: audioUnit.bp4Amp * scaleFactor, threshold: threshold)
        let bp8Amp =  checkThreshold(input: audioUnit.bp8Amp * scaleFactor, threshold: threshold)
        xyPad.circleValues = [bp1Amp, bp4Amp, bp8Amp]
    }
}
