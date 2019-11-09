//
//  ToggleButton.swift
//  FatSynth
//
//  Created by Colin on 06/09/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ToggleButton: UIButton {
    
    var name = "ToggleButton" {
        didSet {
            setNeedsDisplay()
        }
    }
    var toggleOn = false {
        didSet {
            if oldValue != toggleOn {
                callback(toggleOn)
                
            }
            setNeedsDisplay()
        }
    }
    var callback: (Bool) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    override func draw(_ rect: CGRect) {
        EZFXStyleKit.drawToggleButton(frame: rect, resizing: .aspectFit, toggleOn: toggleOn)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        toggleOn = !toggleOn
    }
}
