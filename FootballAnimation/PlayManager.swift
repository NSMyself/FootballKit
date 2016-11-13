//
//  PlayManager.swift
//  FootballAnimation
//
//  Created by João Pereira on 13/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

struct PlayManager {
    
    var view:UIView?
    var viewSize:CGRect = CGRect.zero
    
    init(view: UIView?) {
        if let view = view {
            self.view = view
            viewSize = view.bounds
        }
    }
    
    func play(play: Play?) {
        
        guard (view != nil), let play = play else { return }
        
        wipeClean()
        
        var lastPlace:String? = nil
        
        for player in play.players {
            var alpha = player.position.count == 1 ? 1.0 : 0.5
            
            if let p = player.position.first {
                if let lp = lastPlace {
                    view?.layer.addSublayer(pass(coordinateStart:lp, p))
                }
            }
            
            var lastRun:String? = nil
            
            for c in player.position {
                
                if let lr = lastRun {
                    view?.layer.addSublayer((run(coordinateStart:lr, coordinateEnd:c)))
                }
                
                view?.addSubview(playerCircle(coordinate:c, number: String(player.number), alpha: alpha))
                alpha = alpha + 0.5
                lastRun = c
            }
            
            if let p = player.position.last  {
                lastPlace = p
            }
        }
    }
    
    
    // MARK: - Private methods
    private func playerCircle(coordinate:String, number:String, alpha:Double = 1.0) -> UIView {
        
        let size = viewSize.height / 12.0 * 0.6
        
        // calculate position
        let point = calculatePoint(coordinate: coordinate)
        let rect = CGRect(x: point.x, y: point.y, width:size, height: size)
        
        // draw red circle
        let player:UILabel = {
            $0.frame = rect
            $0.backgroundColor = UIColor.red
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightBold)
            $0.layer.borderWidth = 1.0
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.cornerRadius = rect.size.height / 2.0
            $0.text = number
            $0.alpha = CGFloat(alpha)
            return $0
        }(UILabel())
        
        return player
    }
    
    private func run(coordinateStart:String, coordinateEnd:String) -> CAShapeLayer {
        return line(coordinateStart: coordinateStart, coordinateEnd: coordinateEnd, type: Line.run)
    }
    
    private func pass(coordinateStart:String, _ coordinateEnd:String) -> CAShapeLayer {
        return line(coordinateStart: coordinateStart, coordinateEnd: coordinateEnd, type: Line.pass)
    }
    
    private func line(coordinateStart:String, coordinateEnd:String, type:Line) -> CAShapeLayer {
        
        let size = Double(viewSize.height / 12.0 * 0.6)
        let point1 = calculatePoint(coordinate: coordinateStart, adjustment: size / 2.0)
        let point2 = calculatePoint(coordinate: coordinateEnd, adjustment: size / 2.0)
        
        // Draw line
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        
        let layer:CAShapeLayer = {
            $0.path = path.cgPath
            $0.strokeColor = type.color()
            $0.lineDashPattern = type.dashPattern()
            $0.lineWidth = 3.0
            return $0
        }(CAShapeLayer())
        
        return layer
    }
    
    private func wipeClean() {
     
        view?.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        view?.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
    
    private func calculatePoint(coordinate:String, adjustment:Double = 0) -> CGPoint {
        let squareSize = CGSize(width: viewSize.width / (18.0 + 1.0), height: viewSize.height / (11.0 + 0.8))
        
        let squareOffset = CGPoint(x: squareSize.width / 2.0, y: squareSize.height / 2.0)
        let xString:String = String(coordinate[coordinate.characters.startIndex])
        
        //let yString = String(coordinate.characters.suffix(coordinate.characters.count - 1))
        let yString = String(coordinate.characters.dropFirst())
        
        //let xPosition:Double = coordinate[coordinate.startIndex]
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWYZ"
        let i = alphabet.index(xString.startIndex, offsetBy: 0)
        let xi = alphabet.distance(from: i, to: (alphabet.range(of: xString)?.lowerBound)!)
        
        let xPosition:Double = Double(xi + 1)
        let yPosition:Double = Double(yString)!
        
        let x:Double = (Double(squareSize.width) * (xPosition - 1.0)) + Double(squareOffset.x) * 1.3 + adjustment
        let y:Double = (Double(squareSize.height) * (yPosition - 1.0)) + Double(squareOffset.y) * 1.4 + adjustment
        
        return CGPoint(x: x, y: y)
    }
}
