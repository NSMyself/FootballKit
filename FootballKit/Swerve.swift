//
//  Swerve.swift
//  FootballKit
//
//  Created by João Pereira on 03/04/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

enum SwerveDirection:Double {
    case left = -1
    case right = 1
}

struct Swerve {
    let direction:SwerveDirection
    let factor:Double
    
    init(direction:SwerveDirection, factor:Double = 100) {
        self.direction = direction
        self.factor = factor
    }
}
