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
    
    init(size: CGSize, origin: CGPoint, type: XYPadType) {
        super.init()
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
        
        let newOrigin = CGPoint(x: origin.x - size.width / 2 , y: origin.y - size.height / 2)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(origin: newOrigin, size: size)
        if let image = UIImage(named: emitter) {
           /* let heightScale = size.height / image.size.height / size.height
            let widthScale = size.width / image.size.width
            let scale = widthScale > heightScale ? widthScale : heightScale
            contentsScale = scale*/
            imageLayer.contentsScale = 2
            imageLayer.contentsGravity = CALayerContentsGravity.center
            imageLayer.contents = image.cgImage
            addSublayer(imageLayer)
            
        }
       /* let circle = CAShapeLayer()
        
        circle.path = CGPath(ellipseIn: CGRect(origin: newOrigin, size: size), transform: nil)
        circle.fillColor = UIColor.blue.cgColor
        circle.zPosition = 1
        circle.opacity = 0.7
        addSublayer(circle)*/
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


