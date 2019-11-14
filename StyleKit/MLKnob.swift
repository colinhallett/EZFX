//
//  KnobView.swift
//  AudioKitSynthOne
//
//  Created by AudioKit Contributors on 7/20/17.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

@IBDesignable
class MLKnob: MLControl {

    @IBInspectable var typeInt: Int = 0
    
    var type: XYPadType {
        get {
            return XYPadType.init(rawValue: typeInt)!
        }
    }
    
    public override func draw(_ rect: CGRect) {
        switch type {
        case .Chorus:
            EZFXStyleKit.drawEZOrangeKnob(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, knobValue: controlValue, knobName: knobText)
        case .Spacer:
            EZFXStyleKit.drawEZBlueKnob(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, knobValue: controlValue, knobName: knobText)
        case .Crusher:
            EZFXStyleKit.drawEZRedKnob(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, knobValue: controlValue, knobName: knobText)
        case .Filter:
            EZFXStyleKit.drawEZPurpleKnob(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, knobValue: controlValue, knobName: knobText)
        case .Delay:
            EZFXStyleKit.drawEZGreenKnob(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, knobValue: controlValue, knobName: knobText)
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            lastX = touchPoint.x
            lastY = touchPoint.y
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            setPercentagesWithTouchPoint(touchPoint)
        }
    }

    func setPercentagesWithTouchPoint(_ touchPoint: CGPoint) {
        // Knobs assume up or right is increasing, and down or left is decreasing
        controlValue += (touchPoint.x - lastX) * knobSensitivity
        controlValue -= (touchPoint.y - lastY) * knobSensitivity
        controlValue = (0.0 ... 1.0).clamp(controlValue)
        value = Double(controlValue).denormalized(to: range, taper: taper)
        callback(value)
        lastX = touchPoint.x
        lastY = touchPoint.y
    }

}
