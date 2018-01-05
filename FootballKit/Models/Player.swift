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
    
    let name: Name
    let number: Int
    let dominantFoot: Foot
    var tracker: Tracker
    weak var team: Team?
    weak var delegate: BallActionDelegate?
    
    private(set) public var actions = Queue<ActionRepresentable>()
    
    // MARK: - Init
    init(name: String, number: Int, foot: Foot = .right, at coordinate: Coordinate? = nil, delegate: BallActionDelegate? = nil) {
        self.name = Name(name: name)
        self.number = number
        self.delegate = delegate
        self.tracker = Tracker(position: coordinate ?? .G6)
        self.dominantFoot = foot
    }
    
    // MARK: - Moving
    
    // Since the user hasn't provided us with a duration parameter, we'll simply use the default one (one square per second)
    // As such, we need to know how far away are the two positions in order to simply calculate the duration
    func move(to newPosition:Coordinate, animationCurve curve:UIViewAnimationCurve = .linear) {
        guard let currentPosition = tracker.lastPosition() else {
            return
        }
        
        // Given that the default speed is one square per second, we simply need to:
        // 1. calculate the distance
        // 2. multiply it by the default speed factor (0.5)
        let distance = FieldManager.distance(from: currentPosition, to: newPosition)
        move(to:newPosition, duration: distance * 0.5, animationCurve: curve)
    }
    
    func move(to:Coordinate, duration:Double, animationCurve curve:UIViewAnimationCurve = .linear) {
        track(action: Movement(destination: to, duration: duration, animationCurve: curve))
    }
    
    func holdPosition(duration:Double = 1) {
        track(action: Hold(position:tracker.lastPosition() ?? .G6, duration: duration))
    }
    
    // MARK: - Passing
    func pass(to coordinate:Coordinate, duration:Double, swerve swerveDirection:SwerveDirection? = nil, highBall:Bool) {
        
        guard let direction = swerveDirection else {
            track(action: BallAction(kind: .pass, destination: coordinate, duration: duration, highBall: highBall))
            return
        }
        
        track(action: BallAction(kind: .pass, destination: coordinate, duration: duration, swerve: Swerve(direction: direction), highBall: highBall))
    }
    
    func pass(to coordinate:Coordinate, duration:Double, swerve:Swerve? = nil, highBall:Bool) {
        track(action: BallAction(kind: .pass, destination: coordinate, duration: duration, swerve: swerve, highBall: highBall))
    }
    
    func shoot() {
        
        guard let position = tracker.lastPosition() else {
            fatalError("Player has no registered positions")
        }
        
        actions.enqueue(BallAction(kind: .shoot, destination: FieldManager.nearestGoal(from: position), duration: 0.2))
    }
    
    // MARK: - Location management
    private func track(action: ActionRepresentable) {
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
