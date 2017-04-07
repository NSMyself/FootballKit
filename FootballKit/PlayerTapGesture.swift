//
//  PlayerTapGesture.swift
//  FootballKit
//
//  Created by João Pereira on 06/04/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import UIKit

class PlayerTapGesture:UITapGestureRecognizer {
    let player:Player
    
    init(target: Any?, action: Selector?, player: Player) {
        self.player = player
        super.init(target: target, action: action)
    }
}
