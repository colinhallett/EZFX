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
    var values: [Float] = [0, 0, 0]
    let circleColors: [UIColor] = [
        UIColor(red:1.0, green:0.17, blue:0.46, alpha:1.0),
        UIColor(red:0.10, green:0.05, blue:0.66, alpha:1.0),
        UIColor(red:0.03, green:0.08, blue:0.54, alpha:1.0)]
    
    init(frame: CGRect, type: XYPadType) {
        super.init()
      /*  let test = EQCircle(frame: frame, color: UIColor.blue)
        test.position = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        print (test)
        addSublayer(test)*/
        for index in 0..<averages.count {
            averages[index] = [Float].init(zeros: maxAverage)
        }
        for _ in 0..<3 {
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
    
    var averages: [[Float]] = [[Float].init(zeros: 5), [Float].init(zeros: 5), [Float].init(zeros: 5)]
    var averageIndex = 0
    let maxAverage = 5
    
    func setValues (newValues: [Float], deltaTime: Float) {
        
        averages[0][averageIndex] = newValues[0]
        averages[1][averageIndex] = newValues[1]
        averages[2][averageIndex] = newValues[2]
        averageIndex += 1
        if averageIndex == maxAverage {
            averageIndex = 0
        }
        
        var calculatedAverage: [Float] = [0, 0, 0]
        
        var index = 0
        for average in averages {
            
            var sum: Float = 0
            for average in average {
                sum += average
            }
            calculatedAverage[index] = sum / Float(average.count)
            values[index] = calculatedAverage[index]
            index += 1
        }
        
        /*
        var index = 0
        let amountOfChange: Float = 0.00001
        for value in newValues {
            if value > values[index] {
                values[index] += amountOfChange * deltaTime
            } else if value < values[index] {
                values[index] -= amountOfChange * deltaTime
            }
            if values[index] < 0 {
                values[index] = 0
            } else if values[index] > 1 {
                //values[index] = 1
            }
            index += 1
        }*/
    }
    func startAnimation(updateRate: Double) {
        for i in 0..<values.count {
            eqCircles[i].amplitudeAnimation(value: Double(values[i]), updateRate: updateRate)
        }
    }
}

