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
    let when:Double
    let duration:Double
}
