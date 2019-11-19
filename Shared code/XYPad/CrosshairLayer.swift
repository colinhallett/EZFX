//
//  CrosshairLayer.swift
//  EZFX
//
//  Created by Colin on 19/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class CrosshairLayer: CALayer {
    
    var verticalLine: CAShapeLayer!
    var horizontalLine: CAShapeLayer!
    
    var height: CGFloat!
    var width: CGFloat!
    
    var value: CGPoint!
    
    init(width: CGFloat, height: CGFloat, value: CGPoint) {
        super.init()
        self.height = height
        self.width = width
        self.value = value
        drawHorizontalLine()
        drawVerticalLine()
        opacity = 0
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    func updateSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        drawHorizontalLine()
        drawVerticalLine()
    }
    
    func updatePosition(value: CGPoint) {
        self.value = value
        horizontalLine.position.y = value.y * height
        verticalLine.position.x = value.x * width
    }
    
    func fadeIn() {
        self.opacity = 0.4
    }
    
    func fadeOut() {
        self.opacity = 0
    }
    
    func drawHorizontalLine () {
        horizontalLine = CAShapeLayer()
        let path = UIBezierPath()
        //path.move(to: CGPoint(x: 0, y: value.y * height))
        //path.addLine(to: CGPoint(x: width, y: value.y * height))
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        horizontalLine.path = path.cgPath
        horizontalLine.lineWidth = 2
        horizontalLine.strokeColor = UIColor.white.cgColor
        horizontalLine.fillColor = nil
        horizontalLine.zPosition = 1
        horizontalLine.position.y = value.y * height
        addSublayer(horizontalLine)
    }
    
    func drawVerticalLine() {
        verticalLine = CAShapeLayer()
        let path = UIBezierPath()
       // path.move(to: CGPoint(x: value.x * width, y: 0))
        //path.addLine(to: CGPoint(x: value.x * width, y: height))
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        verticalLine.path = path.cgPath
        verticalLine.lineWidth = 2
        verticalLine.strokeColor = UIColor.white.cgColor
        verticalLine.fillColor = nil
        verticalLine.zPosition = 1
        verticalLine.position.x = value.x * width
        addSublayer(verticalLine)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
