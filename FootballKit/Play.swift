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
    let homeTeam:[Player:[String]]
    let awayTeam:[Player:[String]]
}
