//
//  Random.swift
//  Game1
//
//  Created by Drew Olbrich on 10/3/16.
//  Copyright © 2016 Retroactive Fiasco. All rights reserved.
//

import Foundation

/// Return a random number between min and max.
func random(min: Double, max: Double) -> Double {
    let s = Double(arc4random())/Double(UInt32.max)
    return min*(1.0 - s) + max*s;
}
