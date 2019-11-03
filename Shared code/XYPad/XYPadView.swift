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
            xValue = xValue > 1.0 ? 1.0 : (xValue < 0.0 ? 0.0 : xValue)
            if xValue != oldValue {
                delegate?.setXValue(value: xValue)
            }
            
        }
    }
    var yValue: Double = 0.5  {
        didSet {
            yValue = yValue > 1.0 ? 1.0 : (yValue < 0.0 ? 0.0 : yValue)
            if yValue != oldValue {
               delegate?.setYValue(value: yValue)
            }
        }
    }
    
    var width: CGFloat! 
    var height: CGFloat!
    
    var touchDict = [UITouch: CALayer]()
    
    var padArea: CAShapeLayer!
    var circle: ControlPoint!
    
    var crosshair: CAShapeLayer!
    
    var circleDiameter: CGFloat = 40
    var circleRadius: CGFloat {
        get { return circleDiameter / 2}
    }
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
    
    var firstPathTime: CFTimeInterval = 0
    var targetPathTime: CFTimeInterval = 0
    var targetTimeDuration: CFTimeInterval = 0
    var currentTimeDuration: CFTimeInterval = -1
    
    var recordedPaths = [RecordedPath]()
    var isLooping = true {
        didSet {
            if !isLooping {
                recordedPaths.removeAll()
                startPlayback = false
            }
        }
    }
    var startPlayback = false
    var completedPath = true
    
    @objc func displayCallback() {
        delegate?.dLinkCallback()
        let timeElapsed = displayLink.timestamp - currentTimeDuration
        
        if startPlayback {
            if recordedPaths.isNotEmpty && completedPath {
                completedPath = false
                currentTimeDuration = displayLink.timestamp
                if let path = nextPath() {
                    updateValue(point: CGPoint(x: CGFloat(path.value.xValue) * width, y: CGFloat(path.value.yValue) * height))
                    createFade(point: CGPoint(x: CGFloat(path.value.xValue) * width, y: CGFloat(path.value.yValue) * height))
                }
            }
            if timeElapsed > targetTimeDuration {
                completedPath = true
            }
        } else {
            if let pres = circle.presentation() {
                if pres.frame != circle.frame {
                   // updateValue(point: pres.frame.origin)
                   // createFade(point: pres.frame.origin)
                }
            }
        }
    }
    
    var pathIndex = -1
    
    func nextPath() -> RecordedPath?{
        pathIndex += 1
        if recordedPaths.count > pathIndex {
            
            let path = recordedPaths[pathIndex]
            firstPathTime = path.timeStamp
            let point = CGPoint(x: CGFloat(path.value.xValue) * width, y: CGFloat(path.value.yValue) * height)
            if pathIndex == 1 || pathIndex == recordedPaths.count - 1{
               // addHotSpot(point: point)
            }
            posInView = point
            setCirclePosition(immediate: false)
            if recordedPaths.count > pathIndex + 1 {
                targetPathTime = recordedPaths[pathIndex + 1].timeStamp
                targetTimeDuration = targetPathTime - firstPathTime
            }
            return path
        } else {
            //startPlayback = false
            pathIndex = -1
            return nil
        }
    }
    
    func setupPadArea() {
        if padArea != nil {
            padArea.removeFromSuperlayer()
        }
        padArea = CAShapeLayer()
        padArea.path = CGPath(rect: bounds, transform: nil)
        padArea.lineWidth = 20
        padArea.strokeColor = UIColor.blue.cgColor
        padArea.fillColor = UIColor.blue.cgColor
        padArea.zPosition = -1
        layer.addSublayer(padArea)
        width = bounds.width
        height = bounds.height
        if crosshair != nil {
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
        circle.frame.origin = CGPoint(x: posInView.x, y: posInView.y)
        CATransaction.commit()
    }
    
    func createFade(point: CGPoint) {
        let emission = Fader(position: CGPoint(x: point.x /*- circleDiameter / 2*/, y: point.y /*- circleDiameter / 2*/), size: CGSize(width: circleDiameter, height: circleDiameter))
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
    
    func handleTouch(point: CGPoint) {
        if isLooping {
            let recordedPath = RecordedPath(value: RecordedPath.Value(xValue: Double(point.x / width), yValue: Double(point.y / height)), timeStamp: displayLink.timestamp)
            recordedPaths.append(recordedPath)
        }
        posInView = CGPoint(x: point.x, y: point.y)
        updateValue(point: posInView)
        createFade(point: posInView)
        setCirclePosition(immediate: false)
    }
    func addHotSpot(point: CGPoint) {
        let hotSpot = TouchHotSpot(frame: CGRect(origin: CGPoint(), size: CGSize(width: circleDiameter, height: circleDiameter)))
        hotSpot.frame.origin =  CGPoint(x: posInView.x, y: posInView.y)
        layer.addSublayer(hotSpot)
        hotSpot.startAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            if isLooping {
                recordedPaths.removeAll()
                startPlayback = false
            }
            let location = touch.location(in: self)
            handleTouch(point: location)
            addHotSpot(point: location)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            var location = touch.location(in: self)
            
            location.x = location.x < 0 ? 0 : (location.x > width ? width : location.x)
            location.y = location.y < 0 ? 0 : (location.y > height ? height : location.y)
            handleTouch(point: location)
            
            //addHotSpot(point: location)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            var location = touch.location(in: self)
            location.x = location.x < 0 ? 0 : (location.x > width ? width : location.x)
            location.y = location.y < 0 ? 0 : (location.y > height ? height : location.y)
            handleTouch(point: location)
            
            if let pres = circle.presentation() {
                addHotSpot(point: pres.frame.origin)
            }
            if isLooping {
                startPlayback = true
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
    var padOpacity: Float = 0
    var targetOpacity: Float = 0
    var currentTime: CFTimeInterval = -1
    
    func setBackgroundColor(amount: Float) {
        if currentTime == -1 {
            currentTime = displayLink.timestamp
        }
        let deltaTime = displayLink.timestamp - currentTime
        
        targetOpacity = amount
         
         if padOpacity < targetOpacity {
             padOpacity += 1 * Float(deltaTime)
         } else {
             padOpacity -= 1 * Float(deltaTime)
         }
         
         CATransaction.begin()
         CATransaction.setAnimationDuration(0)
         padArea.opacity = padOpacity
         CATransaction.commit()
        
        currentTime = displayLink.timestamp
    }
    
    struct RecordedPath {
        struct Value {
            var xValue: Double
            var yValue: Double
        }
        var value: Value
        var timeStamp: CFTimeInterval
    }
    
}

protocol XYPadDelegate {
    func setXValue(value: Double)
    func setYValue(value: Double)
    func dLinkCallback() 
}
