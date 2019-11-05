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
    @IBAction func isActiveSwitch(_ sender: UISwitch) {
        isActiveParameter?.setValue(sender.isOn ? 1 : 0, originator: parameterObserverToken)
       }
    @IBOutlet weak var isActiveSwitchOutlet: UISwitch!
    
    @IBAction func mixSlider(_ sender: UISlider) {
        mixParameter?.setValue(sender.value, originator: parameterObserverToken)
    }
    
    @IBOutlet weak var mixSliderOutlet: UISlider!
    
    @IBAction func loopingSwitch(_ sender: UISwitch) {
        xyPad.isLooping = sender.isOn
    }
    
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
        xyPad.setupPadArea()
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
    
    private var xValueParameter: AUParameter?
    private var yValueParameter: AUParameter?
    private var isActiveParameter: AUParameter?
    private var mixParameter: AUParameter?
    
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
        print ("setup params")
       
        guard let tree = audioUnit?.parameterTree else {return}
      
        xValueParameter = tree["xValue"]
        yValueParameter = tree["yValue"]
        isActiveParameter = tree["isActive"]
        mixParameter = tree["mix"]
        
        audioUnit?.rampDuration = 0.00001
    }
    
    func connectUIToAudioUnit() {
        guard let paramTree = audioUnit?.parameterTree else {
                   NSLog("The audio unit has no parameters!")
                   return
               }
        
           parameterObserverToken = paramTree.token(byAddingParameterObserver: { [weak self] address, value in
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
                        strongSelf.isActiveSwitchOutlet.isOn = newValue > 0.5 ? true : false
                   case strongSelf.mixParameter!.address:
                        let newValue = Float(value)
                        strongSelf.mixSliderOutlet.setValue(newValue, animated: true)
                    //set slider
                   default:
                        NSLog("address not found")
                }
            }
        })
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
    func dLinkCallback() {
        guard let audioUnit = audioUnit else {return}
        let lAmp = audioUnit.lowAmplitude
       /* let bp1Amp = audioUnit.bp1Amp
        let bp2Amp = audioUnit.bp2Amp
        let bp3Amp = audioUnit.bp3Amp
        let bp4Amp = audioUnit.bp4Amp
        let bp5Amp = audioUnit.bp5Amp
        let bp6Amp = audioUnit.bp6Amp
        let bp7Amp = audioUnit.bp7Amp
        let bp8Amp = audioUnit.bp8Amp
        let highAmp = audioUnit.highHighAmplitude
        
        lowLevel.text = String(lAmp)
        bp1Level.text = String(bp1Amp)
        bp2Level.text = String(bp2Amp)
        bp3Level.text = String(bp3Amp)
        bp4Level.text = String(bp4Amp)
        bp5Level.text = String(bp5Amp)
        bp6Level.text = String(bp6Amp)
        bp7Level.text = String(bp7Amp)
        bp8Level.text = String(bp8Amp)
        highLevel.text = String(highAmp)*/
        DispatchQueue.main.async {
            self.xyPad.setBackgroundColor(amount: lAmp)
        }
        
    }
}
