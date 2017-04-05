//
//  BallAction.swift
//  FootballKit
//
//  Created by João Pereira on 30/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

enum BallActionKind {
    case pass
    case shoot
}

struct BallAction:Action {
    let kind:BallActionKind
    let destination:Coordinate
    let duration:Double
    let swerve:Swerve?
    let highBall:Bool
    
    init(kind:BallActionKind, destination:Coordinate, duration:Double, swerve:Swerve? = nil, highBall:Bool = false) {
        self.kind = kind
        self.destination = destination
        self.duration = duration
        self.swerve = swerve
        self.highBall = highBall
    }
}
