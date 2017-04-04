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
    var tracker:Tracker
    weak var delegate:BallActionDelegate?
    
    private(set) public var actions = Queue<Action>()
    
    // MARK: - Init
    init(name:String, number:UInt8, at coordinate:Coordinate? = nil, delegate:BallActionDelegate? = nil) {
        self.name = Name(name: name)
        self.number = number
        self.delegate = delegate
        self.tracker = Tracker(position: coordinate ?? .G6)
    }
    
    // MARK: - Moving
    func move(to:Coordinate, duration:Double) {
        track(action: Movement(destination: to, duration: duration))
    }
    
    func holdPosition(duration:Double) {
        track(action: Hold(position:tracker.lastPosition() ?? .G6, duration: duration))
    }
    
    // MARK: - Passing
    func pass(to coordinate: Coordinate, duration:Double, swerve:Swerve? = nil) {
        track(action: BallAction(kind: .pass, destination: coordinate, duration: duration, swerve: swerve))
    }
    
    func pass(to:Player, duration:Double, highBall:Bool = false, swerve:Swerve? = nil) {
        fatalError("Not yet implemented!")
    }
    
    func shoot() {
        
        guard let position = tracker.lastPosition() else {
            fatalError("Not yet implemented")
        }
        
        actions.enqueue(BallAction(kind: .shoot, destination: Field.nearestGoal(from: position), duration: 0.2))
    }
    
    // MARK: - Location management
    private func track(action:Action) {
        actions.enqueue(action)
        
        if ((action is Movement) || (action is Hold)) {
            tracker.set(position: action.destination, duration: action.duration)
        }
    }
    
    func position(at:Double) -> CGPoint {
        // TODO: IMPLEMENT
        return CGPoint.zero
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
