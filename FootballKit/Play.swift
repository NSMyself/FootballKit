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
    var initialBallCarrier:Player?
    
    init(scored:Bool, offside:Bool = false, kind:Kind, homeTeam:Team? = nil, awayTeam:Team? = nil, initialBallCarrier:Player? = nil) {
        self.scored = scored
        self.kind = kind
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.initialBallCarrier = initialBallCarrier
    }
}
