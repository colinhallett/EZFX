//
//  LayerRemover.swift
//  EZFX
//
//  Created by Colin on 21/10/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

class LayerRemover: NSObject, CAAnimationDelegate {
    private weak var layer: CALayer?
    
    init(for layer: CALayer) {
        self.layer = layer
        super.init()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer?.removeFromSuperlayer()
    }
}
