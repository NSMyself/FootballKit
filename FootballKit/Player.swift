//
//  Player.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit
import Foundation

class Player:Equatable, Hashable {
    
    let name:Name
    let number:UInt8
    weak var delegate:BallActionDelegate?
    
    private(set) public var actions = Queue<Action>()
    
    // MARK: - Init
    init(name:String, number:UInt8, at coordinate:Coordinate? = nil, delegate:BallActionDelegate? = nil) {
        self.name = Name(name: name)
        self.number = number
        self.delegate = delegate
        self.move(to:coordinate ?? .G6, duration: 0)
    }
    
    // MARK: - Moving
    func move(to:Coordinate, duration:Double) {
        self.track(action: Movement(destination: to, duration: duration))
    }
    
    func holdPosition(duration:Double) {
        let lastPosition = actions.last?.destination ?? .G6
        track(action: Hold(position:lastPosition, duration: duration))
    }
    
    // MARK: - Passing
    func pass(to coordinate: Coordinate, duration:Double, swerve:Swerve? = nil) {
        track(action: BallAction(kind: .pass, destination: coordinate, duration: duration, swerve: swerve))
    }
    
    func pass(to:Player, duration:Double, highBall:Bool = false, swerve:Swerve? = nil) {
        
        guard to != self else {
            fatalError("Can't pass to self!")
        }
        
        //pass(to: to.currentPosition, duration: duration, swerve: swerve)
    }
    
    func shoot(from location:Coordinate) {
        let y = Field.nearestGoal(from: location)
        track(action: BallAction(kind: .shoot, destination: Field.nearestGoal(from: location), duration: 0.8))
    }
    
    // MARK: - Position retrieval methods
    func initialPosition() -> Coordinate {
        return actions.first?.destination ?? .G6
    }
    
    func position(at:Double) -> CGPoint {
        // TODO: IMPLEMENT
        return CGPoint.zero
    }
    
    // MARK: - Auxiliar methods
    private func track(action:Action) {
        actions.enqueue(action)
    }
}

extension Player {
    // MARK: - Equatable & Hashable protocol compliance
    
    var hashValue: Int {
        return name.hashValue ^ number.hashValue
    }
    
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}
