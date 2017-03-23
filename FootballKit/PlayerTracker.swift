//
//  PlayerTracker.swift
//  FootballKit
//
//  Created by João Pereira on 23/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

typealias Position = [Int: String]

struct PlayerTracker {
    
    fileprivate var tracker:[Player:[Position]]
    
    mutating func register(player:Player, positions:[Position]) {
        
        guard positions.count > 0 else {
            fatalError("Cannot register the player's position array without an actual value")
        }
        
        tracker[player] = positions
    }
}

extension PlayerTracker {
    init() {
        self.tracker = [:]
    }
}
