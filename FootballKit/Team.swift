//
//  Team.swift
//  FootballKit
//
//  Created by João Pereira on 16/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation
import UIKit

class Team {
    let name:String
    let country:String // let's keep it simple for now
    let colour:UIColor
    
    private(set) public var players = Set<Player>()
    
    init(name:String, country:String, players:[Player]? = nil, colour:UIColor) {
        self.name = name
        self.country = country
        self.colour = colour
        
        if let players = players {
            for player in players {
                self.players.insert(player)
            }
        }
    }
    
    func register(player: Player) {
        players.insert(player)
    }
}
