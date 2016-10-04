//
//  Delay.swift
//  Game1
//
//  Created by Drew Olbrich on 10/3/16.
//  Copyright © 2016 Retroactive Fiasco. All rights reserved.
//

import Foundation

func delay(_ delay: TimeInterval, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
