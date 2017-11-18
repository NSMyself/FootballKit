//
//  Hold.swift
//  FootballKit
//
//  Created by João Pereira on 30/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

struct Hold: ActionRepresentable {
    let destination: Coordinate
    let duration: Double
    
    init(position: Coordinate, duration: Double) {
        self.destination = position
        self.duration = duration
    }
}
