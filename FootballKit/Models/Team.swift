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
    let name: String
    let country: String // let's keep it simple for now
    let color: UIColor
    
    private(set) public var players = Set<Player>()
    
    init(name:String, country:String, players:[Player]? = nil, color:UIColor) {
        self.name = name
        self.country = country
        self.color = color
        
        players?.forEach {
            self.players.insert($0)
        }
    }
    
    func register(player: Player) {
        players.insert(player)
        player.team = self
    }
}
