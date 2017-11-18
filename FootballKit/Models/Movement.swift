//
//  Movement.swift
//  FootballKit
//
//  Created by João Pereira on 28/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import UIKit

struct Movement: ActionRepresentable {
    let destination: Coordinate
    let duration: Double
    let animationCurve: UIViewAnimationCurve
    
    init(destination: Coordinate, duration: Double, animationCurve: UIViewAnimationCurve = .linear) {
        self.destination = destination
        self.duration = duration
        self.animationCurve = animationCurve
    }
}
