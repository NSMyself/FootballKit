//
//  PlayerName.swift
//  FootballKit
//
//  Created by João Pereira on 23/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

typealias Name = PlayerName

struct PlayerName:Hashable {
    let full:String?
    let short:String
    let jersey:String
    
    var hashValue: Int {
        return full?.hashValue ?? 0 ^ short.hashValue ^ jersey.hashValue
    }
    
    static func == (lhs:PlayerName, rhs: PlayerName) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension PlayerName {
    init(name:String) {
        self.full = name
        self.short = name
        self.jersey = name
    }
}
