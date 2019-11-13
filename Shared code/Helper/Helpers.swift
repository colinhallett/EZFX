//
//  Helpers.swift
//  EZFX
//
//  Created by Colin on 09/11/2019.
//  Copyright © 2019 ckzh. All rights reserved.
//

import Foundation

func convertToRange(number: Double, inputRange: Range<Double>, outputRange: Range<Double>) -> Double {
    let oldRange = (inputRange.upperBound - inputRange.lowerBound)
    let newRange = (outputRange.upperBound - outputRange.lowerBound)
    let newValue = (((number - inputRange.lowerBound) * newRange) / oldRange) + outputRange.lowerBound
    return newValue
}
