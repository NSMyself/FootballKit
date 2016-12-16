//
//  Event.swift
//  FootballKit
//
//  Created by João Pereira on 16/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

struct Event {
    let timestamp: String
    let kind:EventKind
    let goal:Goal?
    let sequence:[Step]
}

