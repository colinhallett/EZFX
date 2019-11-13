//
//  XYPadDisplayLink.swift
//  EZFX
//
//  Created by Colin on 06/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

extension XYPadView {
    func setCirclePosition(immediate: Bool) {
        let time = immediate ? 0 : 0.05
        CATransaction.begin()
        CATransaction.setAnimationDuration(time)
        circle.frame.origin = CGPoint(x: posInView.x, y: posInView.y)
        CATransaction.commit()
    }
    
    func createFade(point: CGPoint) {
        let emission = Fader(position: CGPoint(x: point.x /*- circleDiameter / 2*/, y: point.y /*- circleDiameter / 2*/), size: CGSize(width: circleDiameter, height: circleDiameter), type: type)
        layer.addSublayer(emission)
        emission.fade()
    }
    
    func updateValue (point: CGPoint) {
        xValue = Double(point.x / width)
        yValue = Double(point.y / height)
        
    }
    
    func updateYPoint(newY: Double) {
        posInView.y = CGFloat(newY) * height //+ circleRadius
        updateValue(point: posInView)
        createFade(point: posInView)
        setCirclePosition(immediate: true)
    }
    func updateXPoint(newX: Double) {
        posInView.x = CGFloat(newX) * width //+ circleRadius
       updateValue(point: posInView)
       createFade(point: posInView)
        setCirclePosition(immediate: true)
    }
}
