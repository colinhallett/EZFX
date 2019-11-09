//
//  Fader.swift
//  EZFX
//
//  Created by Colin on 18/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class Fader : CAEmitterLayer {
    
    init(position: CGPoint, size: CGSize) {
        super.init()
        name = "emitter"
        emitterPosition = position
        opacity = 0.5
        let cell = CAEmitterCell()
        cell.name = "childCell"
        cell.birthRate = 1
        cell.lifetime = 1.5
        cell.velocity = 50
        cell.scale = 0.3
        cell.lifetimeRange = 0.5
        cell.spin = 5
        cell.spinRange = 2
        cell.repeatCount = 0
        
        cell.emissionRange = CGFloat.pi * CGFloat.random(in: -2...2)
        if let image = UIImage(named: "emitter.png") {
            cell.contents = image.cgImage
        }
        emitterCells = [cell]
    }
    
    func fade() {
        let fade = CAKeyframeAnimation(keyPath: "opacity")
        //fade.fromValue = 1.0
        fade.values = [0.5, 0.0]
        fade.duration = 1
        opacity = 0.0
        
        //fade.fillMode = .forwards
        //fade.isRemovedOnCompletion = false
        let layerRemover = LayerRemover(for: self)
        fade.delegate = layerRemover
        let birthRateFade = CAKeyframeAnimation(keyPath: "emitterCells.childCell.birthRate")
        birthRateFade.values = [1.0, 0.0]
        birthRateFade.duration = 1
        emitterCells![0].birthRate = 0
        add(fade, forKey: "fade")
        add(birthRateFade, forKey: "brFade")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


