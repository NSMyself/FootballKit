//
//  PlayManagerDelegate.swift
//  FootballKit
//
//  Created by João Pereira on 06/04/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

protocol PlayManagerDelegate: class {
    func animationDidStart()
    func animationDidStop()
    func scored(player: Player)
    func tapped(player: Player)
}
