//
//  ControlPoint.swift
//  EZFX
//
//  Created by Colin on 20/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class ControlPoint : CALayer {
    
    init(size: CGSize, origin: CGPoint) {
        super.init()
        let circle = CAShapeLayer()
        let newOrigin = CGPoint(x: origin.x - size.width / 2 , y: origin.y - size.height / 2)
        circle.path = CGPath(ellipseIn: CGRect(origin: newOrigin, size: size), transform: nil)
        circle.fillColor = UIColor.blue.cgColor
        circle.zPosition = 1
        circle.opacity = 0.7
        addSublayer(circle)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
}


