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
    var currentSelection = 0 {
        didSet {
            setNeedsDisplay()
            if oldValue != currentSelection {
                callback(currentSelection)
            }
        }
    }
    var name: String {
        get {
            return selectionNames[currentSelection]
        }
    }
    var callback: (Int) -> Void = {_ in }
    
    var selectionNames: [String] = ["Hello"]
    
    override func draw(_ rect: CGRect) {
        EZFXStyleKit.drawSelectionButton(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit, selectionText: name, selected: selected)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        selected = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if currentSelection + 1 >= amountOfSelections {
            currentSelection = 0
        } else {
            currentSelection += 1
        }
        selected = false
    }
    
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
    
}
