//
//  Hold.swift
//  FootballKit
//
//  Created by João Pereira on 30/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

struct Hold:Action {
    let destination:Coordinate
    let when:Double
    let duration:Double
    
    init(position:Coordinate, when:Double = 0, duration:Double) {
        self.destination = position
        self.when = when
        self.duration = duration
    }
}
