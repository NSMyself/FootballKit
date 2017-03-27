//
//  PlayerTracker.swift
//  FootballKit
//
//  Created by João Pereira on 23/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

typealias Positions = [Int: String]

struct PlayerTracker {
    fileprivate var tracker:[Player:Positions]
    fileprivate var duration:Int = 0
    
    mutating func register(player:Player, positions:Positions) {
        
        guard positions.count > 0 else {
            fatalError("Cannot register the player's position array without an actual value")
        }
        
        tracker[player] = positions
        
        duration = positions.count > duration ? positions.count : duration
    }
    
    func players() -> [Player:Positions] {
        return tracker
    }
    
    func animationDuration() -> Int {
        return duration
    }
}

extension PlayerTracker {
    init() {
        self.tracker = [:]
    }
}
