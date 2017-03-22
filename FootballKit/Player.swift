//
//  Player.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Player:Equatable, Hashable {
    
    struct Name:Hashable {
        let full:String?
        let short:String
        let jersey:String
        
        var hashValue: Int {
            return full?.hashValue ?? 0 ^ short.hashValue ^ jersey.hashValue
        }
        
        static func == (lhs:Name, rhs: Name) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    let name:Name
    let number:UInt8
    
    var hashValue: Int {
        return name.hashValue ^ number.hashValue
    }
}
    
extension Player {
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}
