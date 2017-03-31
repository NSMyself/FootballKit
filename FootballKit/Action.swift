//
//  Actions.swift
//  FootballKit
//
//  Created by João Pereira on 30/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

protocol Action {
    var destination:Coordinate { get }
    var duration:Double { get }
}
