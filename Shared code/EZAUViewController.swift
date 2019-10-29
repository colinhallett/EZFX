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
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xyPad.setupPadArea()
    }
    @IBAction func isActiveSwitch(_ sender: UISwitch) {
        isActive = sender.isOn ? 1 : 0
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
    
    var parameterObserverToken: AUParameterObserverToken?
    
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
        audioUnit?.xValue = 0
        audioUnit?.yValue = 0
        audioUnit?.isActive = 1.0
       
        guard let tree = audioUnit?.parameterTree else {return}
      
        xValueParameter = tree["xValue"]
        yValueParameter = tree["yValue"]
        isActiveParameter = tree["isActive"]
       
        audioUnit?.xValue = 0
        audioUnit?.yValue = 0
        audioUnit?.isActive = 1.0
        
        audioUnit?.rampDuration = 0.001
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
                        //set xypad value
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
}