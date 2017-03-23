//
//  Play.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Play {
    let scored:Bool
    let offside:Bool = false
    let kind:Kind
    let ball:[String]
    var homeTeam:PlayerTracker
    var awayTeam:PlayerTracker
}

extension Play {
    init(scored:Bool, offside:Bool = false, kind:Kind, ball:[String]? = nil) {
        self.ball = ball ?? []
        self.scored = scored
        self.kind = kind
        self.homeTeam = PlayerTracker()
        self.awayTeam = PlayerTracker()
    }
}
