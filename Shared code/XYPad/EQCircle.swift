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
    var initialVelocity: CGFloat = 30
    var initalBirthRate: Float = 1
    var maxOpacity: Float = 1
    var imageSize: CGSize!
    init(frame: CGRect, type: XYPadType) {
        super.init()
        emitterSize = frame.size
        emitterMode = .volume
        emitterDepth = .pi * 2
        emitterShape = .point
        //emitterPosition = newPo
        let cell = CAEmitterCell()
        //cell.color = color.cgColor
        cell.name = "childCell"
        cell.birthRate = initalBirthRate
        cell.lifetime = 5
        cell.lifetimeRange = 3
        cell.velocityRange = 50
        cell.velocity = initialVelocity
        cell.scale = initalScale
        cell.scaleRange = 0.03
        cell.scaleSpeed = 0.005
        cell.spin = 20
        cell.spinRange = 2
        cell.alphaSpeed = -1
        //cell.blueSpeed = 0.2
        //cell.blueRange = 3
       // cell.redSpeed = 0.2
        //cell.redRange = 2
        var emitter = "BlueEmitter.png"
        switch type {
            case .Chorus:
                emitter = "OrangeEmitter.png"
            case .Spacer:
                emitter = "BlueEmitter.png"
            case .Crusher:
                emitter = "RedEmitter.png"
            case .Filter:
                emitter = "PurpleEmitter.png"
            case .Delay:
                emitter = "GreenEmitter.png"
        }
        cell.emissionRange = CGFloat.pi * 2// CGFloat.random(in: -10...10)
        if let image = UIImage(named: emitter) {
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
        if value < 0.0001 {
           // return
        }
        let value = CGFloat(value)
        let newBirthrate: Float = initalBirthRate * Float(value) + 1
        setValue(newBirthrate > 2 ? 2 : newBirthrate, forKeyPath: "emitterCells.childCell.birthRate")
        removeAnimation(forKey: "circleAni")
       /* let opacityAni = CAKeyframeAnimation(keyPath: "opacity")
        opacityAni.values = [self.opacity, maxOpacity * Float(value)]
        opacityAni.timingFunction = CAMediaTimingFunction(name: .easeOut)
        self.opacity = maxOpacity * Float(value)*/
        let opacityAni = CAKeyframeAnimation(keyPath: "opacity")
        opacityAni.values = [maxOpacity * Float(value)]
        //self.opacity = maxOpacity * Float(value)
        let group = CAAnimationGroup()
        group.animations = [opacityAni]
        group.duration = 5
        
        self.add(group, forKey: "circleAni")
    }
    
    func setNewSize (frame: CGRect) {
        emitterSize = frame.size
        let widthScale = frame.size.width / imageSize.width
        let heightScale = frame.size.height / imageSize.height
        initalScale = widthScale > heightScale ? widthScale : heightScale
        initialVelocity = initialVelocity * 30;
        setValue(initialVelocity, forKey: "emitterCells.childCell.velocity")
        setValue(initalScale, forKeyPath: "emitterCells.childCell.scale")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
