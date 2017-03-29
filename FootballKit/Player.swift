//
//  Player.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Player:Equatable, Hashable {
    
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
    
    init(name:String, number:UInt8, at coordinate:Coordinate? = nil, ball:Bool = false) {
        self.name = Name(name: name)
        self.number = number
        self.move(to:coordinate ?? .G6, duration: 0, ball: ball)
    }
    
    // MARK: - Moving
    mutating func move(to:Coordinate, duration:Double, ball:Bool = false) {
        self.track(movement: Movement(position: to, duration: duration, hasBall:ball))
    }
    
    mutating func holdPosition(duration:Double) {
        let lastPosition = tracker.last?.position ?? .G6
        self.track(movement: Movement(position: lastPosition, duration: duration, hasBall: (tracker.last?.hasBall ?? false)))
    }
    
    // MARK: - Passing
    mutating func pass(to: Coordinate, duration:Double) {
        
        guard ball else {
            fatalError("Player \(name) doesn't have the ball! Can't pass")
        }
        
        has(ball: false)
        //TODO: pass
        print("E agora falta aqui um passe para (\(to.x),\(to.y))")
    }
    
    mutating func pass(to: Player, duration:Double) {
        pass(to: to.currentPosition, duration: duration)
    }
    
    mutating func shoot(nearest:Bool = true, goal:Bool = false) {
        let marcou = goal ? "" : "não"
        print("Rematou e \(marcou) foi golo")
    }
    
    // MARK: - Position retrival methods
    func initialPosition() -> Coordinate {
        return tracker.first?.position ?? .G6
    }
    
    // MARK: - Private methods
    mutating private func has(ball:Bool) {
        self.ball = ball
    }
    
    mutating private func track(movement:Movement) {
        has(ball: movement.hasBall)
        tracker.append(movement)
    }
}

extension Player {
    
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}
