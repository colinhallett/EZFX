//
//  Fader.swift
//  EZFX
//
//  Created by Colin on 18/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class Fader : CALayer {
    
    init(position: CGPoint, size: CGSize) {
        super.init()
        //self.position = position
        let newPos = CGPoint(x: position.x - size.width / 2, y: position.y - size.height / 2)
        let circle = CAShapeLayer()
        let path = CGPath(ellipseIn: CGRect(origin: newPos, size: size), transform: nil)
        circle.opacity = 0.4
        circle.path = path
        circle.fillColor = UIColor.blue.cgColor
        addSublayer(circle)
        /*
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = newPos
            
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 2
        cell.velocity = 10
        cell.scale = 0.03
        cell.lifetimeRange = 0.5
        cell.spin = 5
        cell.spinRange = 2
        cell.emissionRange = CGFloat.pi * CGFloat.random(in: -2...2)
        cell.contents = UIImage(named: "emitter.png")!.cgImage
        emitter.emitterCells = [cell]
        addSublayer(emitter)*/
    }
    
    func fade() {
        let fade = CABasicAnimation(keyPath: #keyPath(opacity))
        //fade.fromValue = 1.0
        fade.toValue = 0.0
        fade.duration = 2
        fade.fillMode = .forwards
        fade.isRemovedOnCompletion = false
        let layerRemover = LayerRemover(for: self)
        fade.delegate = layerRemover
        add(fade, forKey: "fade")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


