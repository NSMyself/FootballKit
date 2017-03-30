//
//  Play.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

class Play {
    let scored:Bool
    let offside:Bool = false
    let kind:Kind
    var homeTeam:Team?
    var awayTeam:Team?
    
    init(scored:Bool, offside:Bool = false, kind:Kind) {
        self.scored = scored
        self.kind = kind
    }
}
