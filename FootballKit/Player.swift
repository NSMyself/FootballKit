//
//  Player.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

class Player:Equatable, Hashable {
    
    let name:Name
    let number:UInt8
    
    var currentPosition:Coordinate {
        get {
            return tracker.last?.position ?? .G6
        }
    }
    
    var ball:Bool = false
    
    private var tracker:[Movement] = []
    
    var hashValue: Int {
        return name.hashValue ^ number.hashValue
    }
    
    init(name:String, number:UInt8, at coordinate:Coordinate? = nil) {
        self.name = Name(name: name)
        self.number = number
        self.move(to:coordinate ?? .G6, duration: 0)
    }
    
    // MARK: - Moving
    func move(to:Coordinate, duration:Double) {
        self.track(movement: Movement(position: to, duration: duration))
    }
    
    func holdPosition(duration:Double) {
        let lastPosition = tracker.last?.position ?? .G6
        self.track(movement: Movement(position: lastPosition, duration: duration))
    }
    
    // MARK: - Passing
    func pass(to: Coordinate, duration:Double) {
        //TODO: pass
        print("E agora falta aqui um passe para (\(to.x),\(to.y))")
    }
    
    func pass(to: Player, duration:Double) {
        pass(to: to.currentPosition, duration: duration)
    }
    
    func shoot(nearest:Bool = true, goal:Bool = false) {
        let marcou = goal ? "" : "não"
        print("Rematou e \(marcou) foi golo")
    }
    
    // MARK: - Position retrival methods
    func initialPosition() -> Coordinate {
        return tracker.first?.position ?? .G6
    }
    
    // MARK: - Auxiliar methods
    private func track(movement:Movement) {
        tracker.append(movement)
    }
    
    func positions(skipInitial:Bool = false) -> [Movement] {
        
        guard skipInitial, tracker.count > 1 else {
            return tracker
        }
        
        return Array(tracker[1...tracker.count-1])
    }
}

extension Player {
    
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}
