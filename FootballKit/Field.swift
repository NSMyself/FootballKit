//
//  Geometry.swift
//  FootballKit
//
//  Created by João Pereira on 15/12/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation
import UIKit

struct Field {
    
    let size:CGSize
    let adjustment:CGFloat
    
    static let firstGoal:Coordinate = .A6
    static let secondGoal:Coordinate = .R6
    
    func calculatePoint(coordinate:Coordinate) -> CGPoint {
        let squareSize = CGSize(width: size.width / (18.0 + 1.0), height: size.height / (11.0 + 0.8))
        let squareOffset = CGPoint(x: squareSize.width / 2.0, y: squareSize.height / 2.0)

        let x = squareSize.width * CGFloat(Double(coordinate.x) - 1.0) + squareOffset.x * 1.3 + adjustment
        let y = squareSize.height * CGFloat(Double(coordinate.y) - 1.0) + squareOffset.y * 1.4 + adjustment
        
        return CGPoint(x: x, y: y)
    }
    
    static func nearestGoal(from coordinate:Coordinate) -> Coordinate {
        return coordinate.x <= 9 ? firstGoal : secondGoal
    }
}
