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
    
    var hashValue: Int {
        return name.hashValue ^ number.hashValue
    }
}
    
extension Player {
    
    init(name:String, number:UInt8) {
        self.name = Name(name: name)
        self.number = number
    }
    
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}
