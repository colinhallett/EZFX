//
//  XYPadViewTouches.swift
//  EZFX
//
//  Created by Colin on 05/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

extension XYPadView {
    
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
    
}
