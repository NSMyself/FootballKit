//
//  Team.swift
//  FootballKit
//
//  Created by João Pereira on 16/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation
import UIKit

struct Team {
    let name:String
    let country:String // let's keep it simple for now
    var players = Set<Player>()
    let colour:UIColor
    
    mutating func register(player:Player) {
        players.insert(player)
        let x = 1
    }
}

extension Team {
    init(name:String, country:String, colour:UIColor) {
        self.name = name
        self.country = country
        self.colour = colour
    }
}
