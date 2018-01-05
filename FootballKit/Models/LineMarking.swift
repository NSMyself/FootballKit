//
//  LineMarking.swift
//  FootballKit
//
//  Created by João Pereira on 17/12/2017.
//  Copyright © 2017 nsmyself. All rights reserved.
//

import UIKit

enum LineMarking {
    case vertical
    case horizontal
    
    func size(considering largestDimension: CGFloat) -> CGSize {
        return self == .vertical ? CGSize(width: 1, height: largestDimension) : CGSize(width: largestDimension, height: 1)
    }
}
