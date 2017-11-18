//
//  Match.swift
//  FootballKit
//
//  Created by João Pereira on 16/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Match {
    let date: Date
    let competition: String  // let's keep it simple for now
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
    let timeline: [Play]
}
