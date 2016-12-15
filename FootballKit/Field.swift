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
    
    static func calculatePoint(coordinate:String, size:CGSize, adjustment: CGFloat) -> CGPoint {
        let squareSize = CGSize(width: size.width / (18.0 + 1.0), height: size.height / (11.0 + 0.8))
        
        let squareOffset = CGPoint(x: squareSize.width / 2.0, y: squareSize.height / 2.0)
        let xString:String = String(coordinate[coordinate.characters.startIndex])
        
        let yString = String(coordinate.characters.dropFirst())
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWYZ"
        let i = alphabet.index(xString.startIndex, offsetBy: 0)
        let xi = alphabet.distance(from: i, to: (alphabet.range(of: xString)?.lowerBound)!)
        
        let xPosition:Double = Double(xi + 1)
        let yPosition:Double = Double(yString)!
        
        let x = squareSize.width * CGFloat(xPosition - 1.0) + squareOffset.x * 1.3 + adjustment
        let y = squareSize.height * CGFloat(yPosition - 1.0) + squareOffset.y * 1.4 + adjustment
        
        return CGPoint(x: x, y: y)
    }
    
    static func dribbleBallPosition(p1:CGPoint, p2:CGPoint, radius:CGFloat = 50) -> CGPoint {
        
        let angle = p1.angleToPoint(comparisonPoint: p2)
        print("Angle is \(angle)")
        
        let x = cos(angle) * radius/2
        let y = sin(angle) * radius/2
        
        return CGPoint(x: p1.x + x, y: p1.y + y)
    }
}
