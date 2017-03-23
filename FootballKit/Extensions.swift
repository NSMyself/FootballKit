//
//  Extensions.swift
//  FootballKit
//
//  Created by João Pereira on 12/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

extension UIBezierPath {
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath.init()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
}

extension CGPoint {
    func angleToPoint(comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - self.x
        let originY = comparisonPoint.y - self.y
        return CGFloat(atan2f(Float(originY), Float(originX)))
    }
}

extension String: Error {}
