//
//  EQCircle.swift
//  EZFX
//
//  Created by Colin on 05/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class EQCircle : CAEmitterLayer {
    
    var initalScale: CGFloat = 1
    var initalBirthRate: Float = 3
    var maxOpacity: Float = 10
    var imageSize: CGSize!
    init(frame: CGRect, color: UIColor) {
        super.init()
        emitterSize = frame.size
        emitterMode = .volume
        emitterDepth = .pi * 2
        emitterShape = .point
        //emitterPosition = newPo
        let cell = CAEmitterCell()
        cell.color = color.cgColor
        cell.name = "childCell"
        cell.birthRate = initalBirthRate
        cell.lifetime = 5
        cell.lifetimeRange = 3
        cell.velocityRange = 50
        cell.velocity = 30
        cell.scale = initalScale
        cell.scaleRange = 0.03
        cell.scaleSpeed = 0.005
        cell.spin = 20
        cell.spinRange = 2
        cell.alphaSpeed = -1/5
        //cell.blueSpeed = 0.2
        //cell.blueRange = 3
       // cell.redSpeed = 0.2
        //cell.redRange = 2
        cell.emissionRange = CGFloat.pi * 2// CGFloat.random(in: -10...10)
        if let image = UIImage(named: "emitter.png") {
            imageSize = image.size
            let widthScale = frame.size.width / imageSize.width
            let heightScale = frame.size.height / imageSize.height
            cell.contents = image.cgImage
            initalScale = widthScale > heightScale ? widthScale : heightScale
        }
        emitterCells = [cell]
     /*   let anotherCell = CAEmitterCell()
        anotherCell.name = "childCell"
        anotherCell.birthRate = 100
        anotherCell.lifetime = 10
        anotherCell.lifetimeRange = 3
        anotherCell.velocityRange = 15
        anotherCell.velocity = 100
        anotherCell.scale = 0.005
        anotherCell.scaleRange = 0.03
        anotherCell.scaleSpeed = 0.005
        anotherCell.spin = 20
        anotherCell.spinRange = 2
        anotherCell.color = color.cgColor
        anotherCell.alphaSpeed = 1/10
        anotherCell.emissionRange = CGFloat.pi * 2// CGFloat.random(in: -10...10)
        if let image = UIImage(named: "spark.png") {
            anotherCell.contents = image.cgImage
        }
        emitterCells = [anotherCell]
        //renderMode = .oldestFirst*/
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func amplitudeAnimation(value: Double, updateRate: Double) {
        let value = CGFloat(value)
        setValue(Float(initalBirthRate * Float(value)) + 1, forKeyPath: "emitterCells.childCell.birthRate")
        let opacityAni = CAKeyframeAnimation(keyPath: "opacity")
        opacityAni.values = [self.opacity, maxOpacity * Float(value)]
        opacityAni.timingFunction = CAMediaTimingFunction(name: .easeOut)
        self.opacity = maxOpacity * Float(value)
        let group = CAAnimationGroup()
        group.animations = [opacityAni]
        group.duration = 1
        
        self.add(group, forKey: "circleAni")
    }
    
    func setNewSize (frame: CGRect) {
        emitterSize = frame.size
        let widthScale = frame.size.width / imageSize.width
        let heightScale = frame.size.height / imageSize.height
        initalScale = widthScale > heightScale ? widthScale : heightScale
        setValue(initalScale, forKeyPath: "emitterCells.childCell.scale")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}