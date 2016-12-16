//
//  Match.swift
//  FootballKit
//
//  Created by João Pereira on 16/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Match {
    let id:Int
    let date:Date
    let competition:String
    let homeTeam:Team
    let awayTeam:Team
    let timeline:[Event]
    let firstHalf:[Goal]
    let secondHalf:[Goal]
}
