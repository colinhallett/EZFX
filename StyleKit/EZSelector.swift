//
//  EZSelector.swift
//  EZFX
//
//  Created by Colin on 14/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class EZSelector: UIView {
    
    var selected = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var amountOfSelections: Int {
        get {
            return selectionNames.count
        }
    }
    var currentSelection = 0
    var name: String {
        get {
            return selectionNames[currentSelection]
        }
    }
    @IBInspectable var selectionNames: [String] = []
    
    override func draw(_ rect: CGRect) {
        EZFXStyleKit.drawSelectionButton(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, selectionText: name, selected: selected)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        selected = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if currentSelection + 1 > amountOfSelections {
            currentSelection = 0
        } else {
            currentSelection += 1
        }
        selected = false
    }
    
}
