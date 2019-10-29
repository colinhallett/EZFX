//
//  TouchHotSpot.swift
//  EZFX
//
//  Created by Colin on 21/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class TouchHotSpot: CAShapeLayer {
    
    init(frame: CGRect) {
        super.init()
        let newOrigin = CGPoint(x: frame.origin.x - frame.size.width / 2 , y: frame.origin.y - frame.size.height / 2)
        path = CGPath(ellipseIn: CGRect(origin: newOrigin, size: frame.size), transform: nil)
        fillColor = UIColor.white.cgColor
        anchorPoint = CGPoint(x: 0, y: 0)
        
        bounds = frame
        opacity = 0.4
        
        zPosition = 2
    }
    
    func startAnimation() {
        let layerRemover = LayerRemover(for: self)
        
        let fade = CABasicAnimation(keyPath: #keyPath(opacity))
        fade.toValue = 0.0
        
        let scale = CABasicAnimation(keyPath: #keyPath(transform))
        scale.byValue = CATransform3DMakeScale(5, 5, 1)

        let ani = CAAnimationGroup()
        ani.animations = [fade, scale]
        ani.duration = 2
        ani.fillMode = .forwards
        ani.isRemovedOnCompletion = false
        ani.delegate = layerRemover
        
        add(ani, forKey: "group")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
}
