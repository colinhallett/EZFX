//
//  VisualiserLayer.swift
//  EZFX
//
//  Created by Colin on 05/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class VisualiserLayer : CALayer {
   
    var eqCircles = [EQCircle]()
    var values: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let circleColors: [UIColor] = [
        UIColor(red:1.0, green:0.17, blue:0.46, alpha:1.0), // lp
        UIColor(red:0.10, green:0.05, blue:0.66, alpha:1.0), //1
        UIColor(red:0.03, green:0.08, blue:0.54, alpha:1.0), // 2
        UIColor(red:0.11, green:0.16, blue:0.68, alpha:1.0), //3
        UIColor(red:0.23, green:0.29, blue:0.79, alpha:1.0), // 4
        UIColor(red:1, green:1, blue:1, alpha:1.0),           //5
        UIColor(red:0.64, green:1.0, blue:0.87, alpha:1.0), // 6
        UIColor(red:0.73, green:0.82, blue:0.95, alpha:1.0), //7
        UIColor(red:0.84, green:0.86, blue:0.95, alpha:1.0), // 8
        UIColor(red:1.0, green:1.0, blue:1.00, alpha:1.0)] //9
    
    init(frame: CGRect, type: XYPadType) {
        super.init()
      /*  let test = EQCircle(frame: frame, color: UIColor.blue)
        test.position = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        print (test)
        addSublayer(test)*/
        
        for nothing in circleColors {
            let newCircle = EQCircle(frame: frame, type: type)
            newCircle.position = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            eqCircles.append(newCircle)
            addSublayer(newCircle)
        }
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    func setNewFrameSize (frame: CGRect) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        for circle in eqCircles {
            circle.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            
            circle.setNewSize(frame: frame)
        }
        CATransaction.commit()
    }
    
    func setValues (newValues: [Float], deltaTime: Float) {
        var index = 0
        for value in newValues {
            if value > values[index] {
                values[index] += 1 * deltaTime
            } else if value < values[index] {
                values[index] -= 1 * deltaTime
            }
            if values[index] < 0 {
                values[index] = 0
            } else if values[index] > 1 {
                values[index] = 1
            }
            index += 1
        }
    }
    func startAnimation(updateRate: Double) {
        for i in 0..<values.count {
            eqCircles[i].amplitudeAnimation(value: Double(values[i]), updateRate: updateRate)
        }
    }
}

