//
//  PlayManagerDelegate.swift
//  FootballKit
//
//  Created by João Pereira on 06/04/17.
//  Copyright © 2017 NSMyself. All rights reserved.
//

import Foundation

protocol PlayManagerDelegate: class {
    func animationStarted()
    func animationEnded()
    func goal(scorer:Player)
}
