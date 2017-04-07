//
//  Tracker.swift
//  FootballKit
//
//  Created by João Pereira on 04/04/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import UIKit
import Foundation

struct Tracker {
    private var positions = [Double:Coordinate]()
    private(set) public var timer:Double = 0
    
    init(position:Coordinate) {
        positions[0] = position
    }
    
    func initialPosition() -> Coordinate {
        return positions[0] ?? .G6
    }
    
    mutating func set(position:Coordinate, duration:Double) {
        timer += duration
        positions[duration] = position
    }
    
    func position(when:Double) -> Coordinate? {
        
        // Input validation
        guard when > 0 else {
            return nil
        }
        
        guard let highestKey = positions.keys.max() else {
            return nil
        }
        
        // Actual position detection
        guard let directMatch = positions[when] else {
            
            if when >= highestKey {
                return positions[highestKey]
            }
            else {
                
                let keys = positions.keys.filter { $0 < when }.sorted()
                
                guard let lastKey = keys.last else {
                    return nil
                }
                
                return positions[lastKey]
            }
        }
        
        return directMatch
    }
    
    func lastPosition() -> Coordinate? {

        guard let highestKey = positions.keys.max() else {
            return nil
        }
        
        return positions[highestKey]
    }
}
