//
//  PlayManager.swift
//  FootballKit
//
//  Created by João Pereira on 13/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

struct PlayManager {
    
    let view:UIView
    var playerRadius:CGFloat = 50
    let ballRadius:CGFloat = 14
    
    init(view: UIView) {
        self.view = view
    }
    
    func play(play: Play?) {
        
        guard let play = play else { return }
        
        wipeClean()
        
        var lastPlace:String? = nil
        
        for player in play.players {
            var alpha = player.position.count == 1 ? 1.0 : 0.5
            
            if let p = player.position.first {
                if let lp = lastPlace {
                    view.layer.addSublayer(pass(coordinateStart:lp, p))
                }
            }
            
            var lastRun:String? = nil
            
            for c in player.position {
                
                if let lr = lastRun {
                    view.layer.addSublayer((run(coordinateStart:lr, coordinateEnd:c)))
                }
                
                view.addSubview(playerCircle(coordinate:c, number: String(player.number), alpha: alpha))
                alpha = alpha + 0.5
                lastRun = c
            }
            
            if let p = player.position.last  {
                lastPlace = p
            }
        }
    }
    
    func animate(play: Play) {
        
        guard let initialCoord = play.players.first?.position.first,
            let lastCoord = play.players.last?.position.last else {
                print("NO DATA")
                return
        }
        
        print("Initial Coord: \(initialCoord)")
        print("Last Coord: \(lastCoord)")
        
        var initialPosition = Field.calculatePoint(coordinate: "H1", size: view.bounds.size, adjustment: 0)
        var lastPosition = Field.calculatePoint(coordinate: "E1", size: view.bounds.size, adjustment: 0)
        
        initialPosition = CGPoint(x: initialPosition.x + 10, y: initialPosition.y + 14)
        lastPosition = CGPoint(x: lastPosition.x + 10, y: initialPosition.y + 14)
        
        print("Initial Position \(initialPosition)")
        print("Last Position \(lastPosition)")
        
        let ball:UIView = {
            $0.frame = CGRect(origin: CGPoint.zero, size:CGSize(width: ballRadius, height: ballRadius))
            $0.center = Field.dribbleBallPosition(p1: initialPosition, p2: lastPosition)
            $0.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 196/255, blue: 15/255, alpha: 1)
            $0.layer.cornerRadius = ballRadius/2
            return $0
        }(UIView())
        
        view.addSubview(ball)
        
        let ballMovement = CABasicAnimation(keyPath: "position")
        ballMovement.fromValue = ball.center
        ballMovement.toValue = CGPoint.zero
        ballMovement.duration = 4
        ballMovement.repeatCount = 1
        ballMovement.isRemovedOnCompletion = false
        ballMovement.fillMode = kCAFillModeForwards
        ball.layer.add(ballMovement, forKey: nil)
    }
    
    
    // MARK: - Private methods
    private func playerCircle(coordinate:String, number:String, alpha:Double = 1.0) -> UIView {
        
        // calculate position
        let point = Field.calculatePoint(coordinate: coordinate, size: view.bounds.size, adjustment: 0)
        
        // draw red circle
        let player:UILabel = {
            $0.frame = CGRect(x: point.x, y: point.y, width:playerRadius, height: playerRadius)
            $0.backgroundColor = UIColor.red
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightBold)
            $0.layer.borderWidth = 1.0
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.cornerRadius = playerRadius / 2.0
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
        
        let size = Double(view.bounds.size.height / 12.0 * 0.6)
        let adjustment = CGFloat(size)/2.0
        
        let point1 = Field.calculatePoint(coordinate: coordinateStart, size:view.bounds.size, adjustment: adjustment)
        let point2 = Field.calculatePoint(coordinate: coordinateEnd, size:view.bounds.size, adjustment: adjustment)
        
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
        
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        view.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
}
