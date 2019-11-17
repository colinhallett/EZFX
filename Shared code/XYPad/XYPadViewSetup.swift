//
//  XYPadViewSetup.swift
//  EZFX
//
//  Created by Colin on 05/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

extension XYPadView {
    func setupPadArea() {
        if height == frame.height || width == frame.width {
            return
        }
        if padArea != nil {
            padArea.removeFromSuperlayer()
        }
        padArea = CAShapeLayer()
        padArea.path = CGPath(rect: bounds, transform: nil)
        padArea.lineWidth = 20
        padArea.strokeColor = nil//UIColor.white.cgColor
        padArea.fillColor = nil//UIColor.black.cgColor
        padArea.zPosition = -1
        layer.addSublayer(padArea)
        width = bounds.width
        height = bounds.height
       /* if crosshair != nil {
            crosshair.removeFromSuperlayer()
        }
        crosshair = CAShapeLayer()
        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: 0, y: height / 2))
        crossPath.addLine(to: CGPoint(x: width, y: height / 2))
        crossPath.move(to: CGPoint(x: width/2, y: 0))
        crossPath.addLine(to: CGPoint(x: width/2, y: height))
        crosshair.path = crossPath.cgPath
        crosshair.lineWidth = 2
        crosshair.strokeColor = UIColor.white.cgColor
        crosshair.fillColor = nil
        crosshair.zPosition = 1
        layer.addSublayer(crosshair)
        */
        if circle != nil {
            posInView = CGPoint(x: CGFloat(xValue) * width, y:  CGFloat(yValue) * height)
            setCirclePosition(immediate: true)
        }
        
        if visualiserLayer != nil {
            //visualiserLayer.position = circle.position
            visualiserLayer.bounds = bounds
            visualiserLayer.masksToBounds = true
            visualiserLayer.setNewFrameSize(frame: frame)
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            visualiserLayer.position = CGPoint(x: width / 2, y: height / 2)
            CATransaction.commit()
        }
        
    }
    
    func setupCircle() {
        circle = ControlPoint(size: CGSize(width: circleDiameter, height: circleDiameter), origin: CGPoint(), type: type)
        circle.frame.origin = posInView
        layer.addSublayer(circle)
        
    }
    
    func setupVisualiserLayer() {
        visualiserLayer = VisualiserLayer(frame: bounds, type: type)
        visualiserLayer.bounds = bounds
        visualiserLayer.masksToBounds = true
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        visualiserLayer.position = CGPoint(x: width / 2, y: height / 2)
        CATransaction.commit()
        visualiserLayer.setNewFrameSize(frame: frame)
        layer.addSublayer(visualiserLayer)
        setNeedsDisplay()
        
        
   }
}
