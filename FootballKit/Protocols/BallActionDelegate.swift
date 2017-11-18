//
//  BallActionDelegate.swift
//  FootballKit
//
//  Created by João Pereira on 30/03/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

protocol BallActionDelegate: class {
    func did(player: Player, perform action: ActionRepresentable)
}
