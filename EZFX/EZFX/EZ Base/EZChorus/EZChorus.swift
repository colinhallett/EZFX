//
//  EZChorus.swift
//  AudioKit
//
//  Created by Colin on 28/10/2019.
//  Copyright © 2019 AudioKit. All rights reserved.
//


import Foundation

open class EZChorus: AKNode, AKToggleable, AKComponent, AKInput {
    
    public var isStarted: Bool {
        return internalAU?.isPlaying ?? false
    }
    
    fileprivate var xValueParameter: AUParameter?
    fileprivate var yValueParameter: AUParameter?
    fileprivate var isActiveParameter: AUParameter?
    fileprivate var mixParameter: AUParameter?
    fileprivate var inputLevelParameter: AUParameter?
    fileprivate var outputLevelParameter: AUParameter?
    
    public typealias AKAudioUnitType = EZChorusAU
    
    public static let ComponentDescription = AudioComponentDescription(effect: "ezch")

    // MARK: - Properties
    private var internalAU: AKAudioUnitType?
    
    /*
    @objc open dynamic var mixValue: Double = 1.0 {
        willSet {
            guard mixValue != newValue else { return }
            if internalAU?.isSetUp == true {
                mixParameter?.value = AUValue(newValue)
                return
            } else {
                internalAU?.mix = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var xValue: Double = 0.0 {
        willSet {
            guard xValue != newValue else { return }
            if internalAU?.isSetUp == true {
                xValueParameter?.value = AUValue(newValue)
                return
            } else {
                internalAU?.xValue = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var yValue: Double = 0.0 {
        willSet {
            guard yValue != newValue else { return }
            if internalAU?.isSetUp == true {
                yValueParameter?.value = AUValue(newValue)
                return
            } else {
                internalAU?.yValue = AUValue(newValue)
            }
        }
    }
    @objc open dynamic var isActive: Double = 0.0 {
        willSet {
            guard isActive != newValue else { return }
            if internalAU?.isSetUp == true {
                isActiveParameter?.value = AUValue(newValue)
                return
            } else {
                internalAU?.isActive = AUValue(newValue)
            }
        }
    }*/
    
    @objc public init( _ input: AKNode? = nil)
    {
        _Self.register()

        super.init()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { [weak self] avAudioUnit in
            guard let strongSelf = self else {
                AKLog("Error: self is nil")
                return
            }
            strongSelf.avAudioUnit = avAudioUnit
            strongSelf.avAudioNode = avAudioUnit
            strongSelf.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
            input?.connect(to: strongSelf)
        }

        internalAU?.xValue = 0.5
        internalAU?.yValue = 0.5
        internalAU?.isActive = 1.0
        internalAU?.mix = 1.0
        internalAU?.inputLevel = 0.0
        internalAU?.outputLevel = 0.0
        
        
        guard let tree = internalAU?.parameterTree else {return}
        print (tree.allParameters)
        xValueParameter = tree["xValue"]
        yValueParameter = tree["yValue"]
        isActiveParameter = tree["isActive"]
        mixParameter = tree["mix"]
        inputLevelParameter = tree["inputLevel"]
        outputLevelParameter = tree["outputLevel"]
    }

    
    public func start() {
        internalAU?.start()
    }
    
    public func stop() {
        internalAU?.stop()
    }
    
}
