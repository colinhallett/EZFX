//
//  XYPadView.swift
//  EZFX
//
//  Created by Colin on 18/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class XYPadView: UIView {
    
    var posInView = CGPoint()
    
    var xValue: Double = 0.5 {
        didSet {
            delegate?.setXValue(value: xValue)
        }
    }
    var yValue: Double = 0.5  {
        didSet {
            delegate?.setYValue(value: yValue)
        }
    }
    
    var width: CGFloat!
    var height: CGFloat!
    
    var touchDict = [UITouch: CALayer]()
    
    var padArea: CAShapeLayer!
    var circle: ControlPoint!
    
    var circleDiameter: CGFloat = 40
    var delegate: XYPadDelegate?
    
    var displayLink: CADisplayLink!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPadArea()
        setupCircle()
        setupDisplayLink()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPadArea()
        setupCircle()
        setupDisplayLink()
    }
    
    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayCallback))
        displayLink.add(to: .main, forMode: .default)
    }
    @objc func displayCallback() {
        if let pres = circle.presentation() {
            if pres.frame != circle.frame {
                updateValue(point: pres.frame.origin)
                createFade(point: pres.frame.origin)
            }
        }
    }
    func setupPadArea() {
        if padArea != nil {
            padArea.removeFromSuperlayer()
        }
        padArea = CAShapeLayer()
        padArea.path = CGPath(rect: bounds, transform: nil)
        padArea.lineWidth = 20
        padArea.strokeColor = UIColor.white.cgColor
        padArea.fillColor = UIColor.black.cgColor
        padArea.zPosition = -1
        layer.addSublayer(padArea)
        width = bounds.width
        height = bounds.height
        if circle != nil {
            posInView = CGPoint(x: CGFloat(xValue) * width, y:  CGFloat(yValue) * height)
            setCirclePosition(immediate: true)
        }
        //setupCircle()
    }
    
    func setupCircle() {
        circle = ControlPoint(size: CGSize(width: circleDiameter, height: circleDiameter), origin: CGPoint())
        circle.frame.origin = posInView
        layer.addSublayer(circle)
        
    }
    
    func setCirclePosition(immediate: Bool) {
        let time = immediate ? 0 : 0.05
        CATransaction.begin()
        CATransaction.setAnimationDuration(time)
        circle.frame.origin = CGPoint(x: posInView.x - circleDiameter / 2, y: posInView.y - circleDiameter / 2)
        testLine.strokeEnd = 1.0
        CATransaction.commit()
        
    }
    
    func createFade(point: CGPoint) {
        let emission = Fader(position: CGPoint(x: point.x - circleDiameter / 2, y: point.y - circleDiameter / 2), size: CGSize(width: circleDiameter, height: circleDiameter))
        layer.addSublayer(emission)
        emission.fade()
    }
    
    func updateValue (point: CGPoint) {
        xValue = Double(point.x / width)
        yValue = Double(point.y / height)
    }
    
    var strokePath = UIBezierPath()
    var testLine = CAShapeLayer()
    
    func handleTouch(point: CGPoint) {
        testLine.path = strokePath.cgPath
        testLine.strokeColor = UIColor.blue.cgColor
        testLine.fillColor = nil
        
        testLine.strokeEnd = 0.0
        
        layer.addSublayer(testLine)
        
        posInView = point
        setCirclePosition(immediate: false)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            strokePath.move(to: location)
            handleTouch(point: location)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            strokePath.addLine(to: location)
            handleTouch(point: location)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            strokePath.addLine(to: location)
            handleTouch(point: location)
            strokePath.removeAllPoints()
            testLine.path = nil
            testLine.removeFromSuperlayer()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
}

protocol XYPadDelegate {
    func setXValue(value: Double)
    func setYValue(value: Double)
}
