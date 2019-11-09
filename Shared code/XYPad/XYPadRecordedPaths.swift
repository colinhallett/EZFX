//
//  EXPadRecordedPaths.swift
//  EZFX
//
//  Created by Colin on 06/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation
import UIKit

extension XYPadView {
    func nextPath() -> RecordedPath?{
           pathIndex += 1
           if recordedPaths.count > pathIndex {
               
               let path = recordedPaths[pathIndex]
               firstPathTime = path.timeStamp
               let point = CGPoint(x: CGFloat(path.value.xValue) * width, y: CGFloat(path.value.yValue) * height)
               if pathIndex == 1 || pathIndex == recordedPaths.count - 1{
                  // addHotSpot(point: point)
               }
               posInView = point
               setCirclePosition(immediate: false)
               if recordedPaths.count > pathIndex + 1 {
                   targetPathTime = recordedPaths[pathIndex + 1].timeStamp
                   targetTimeDuration = targetPathTime - firstPathTime
               }
               return path
           } else {
               //startPlayback = false
               pathIndex = -1
               return nil
           }
       }
       
    ///recorded path struct
    struct RecordedPath {
        struct Value {
            var xValue: Double
            var yValue: Double
        }
        var value: Value
        var timeStamp: CFTimeInterval
    }
}
