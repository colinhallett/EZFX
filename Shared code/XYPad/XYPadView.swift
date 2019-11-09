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
    override var bounds: CGRect {
        didSet {
            setupPadArea()
        }
    }
  
    
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
    
    var visualiserLayer: VisualiserLayer!
    
    var displayLink: CADisplayLink!
    
    var padOpacity: Float = 0
    var targetOpacity: Float = 0
    var currentTime: CFTimeInterval = -1
    
    var circleValues = [Float]()
    
    ///recording paths
      
      var firstPathTime: CFTimeInterval = 0
      var targetPathTime: CFTimeInterval = 0
      var targetTimeDuration: CFTimeInterval = 0
      var currentTimeDuration: CFTimeInterval = -1
      
      var recordedPaths = [RecordedPath]()
      var isLooping = false {
          didSet {
              if !isLooping {
                  recordedPaths.removeAll()
                  startPlayback = false
              }
          }
      }
      var startPlayback = false
      var completedPath = true
      var counter = 0
      
      var pathIndex = -1
    
    ///init
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        setupPadArea()
        setupCircle()
        setupVisualiserLayer()
        setupDisplayLink()
        setupPadArea()
    }
 
    ///display link
    func setupDisplayLink() {
           displayLink = CADisplayLink(target: self, selector: #selector(displayCallback))
           displayLink.add(to: .main, forMode: .default)
       }
    
   @objc func displayCallback() {
       delegate?.dLinkCallback()
       let frames = 0
        let deltaTime = displayLink.timestamp - currentTime
        visualiserLayer.setValues(newValues: circleValues, deltaTime: Float(deltaTime))
       if counter == Int(frames) {
           visualiserLayer.startAnimation(updateRate: Double(frames))
           counter = 0
       }
       //counter += 1
       
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
    
    ///background set color
    
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
    
   
       
       
    
}

protocol XYPadDelegate {
    func setXValue(value: Double)
    func setYValue(value: Double)
    func dLinkCallback() 
}
