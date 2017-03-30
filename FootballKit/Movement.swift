//
//  Movement.swift
//  FootballKit
//
//  Created by João Pereira on 28/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

struct Movement {
    let position:Coordinate
    let when:Double
    let duration:Double
    
    init(position:Coordinate, when:Double = 0, duration:Double) {
        self.position = position
        self.when = when
        self.duration = duration
    }
}
