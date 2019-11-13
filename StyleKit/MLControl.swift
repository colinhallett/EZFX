//
//  MLControl.swift
//  MelodyLive2
//
//  Created by Colin on 22/08/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

public class MLControl: UIView {
    var onlyIntegers: Bool = false
    
    var callback: (Double) -> Void = { _ in }
    
    public var taper: Double = 1.0 // Linear by default
    
    var knobNameLogic: (Double) -> String = { _ in return ""}
    
    var knobName: String = "TestName" {
        didSet {
            knobText = knobName
        }
    }
    var knobText: String = "TestName" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var range: ClosedRange = 0.0...1.0 {
        didSet {
            _value = range.clamp(_value)
            controlValue = CGFloat(Double(controlValue).normalized(from: range, taper: taper))
        }
    }
    
    private var _value: Double = 0
    
    var value: Double {
        get {
            return _value
        }
        set(newValue) {
            _value = onlyIntegers ? round(newValue) : newValue
            _value = range.clamp(_value)
         //   controlValue = CGFloat(newValue.normalized(from: range, taper: taper))
            controlValue = CGFloat(_value.normalized(from: range, taper: taper))
            let newName = knobNameLogic(newValue)
            
            if newName != "" {
                knobText = newName
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    if self.knobText == newName {
                        self.knobText = self.knobName
                    }
                }
            }
        }
    }
    
    // Knob properties
    var controlValue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var knobFill: CGFloat = 0
    
    var knobSensitivity: CGFloat = 0.005
    
    var lastX: CGFloat = 0
    
    var lastY: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    public class override var requiresConstraintBasedLayout: Bool {
        return true
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.knobText = self.knobName
        }
    }
    
}
