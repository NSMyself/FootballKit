//
//  PlayManager.swift
//  FootballKit
//
//  Created by João Pereira on 13/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit
import EasyAnimation

struct PlayManager {
    
    let view:UIView
    var playerRadius:CGFloat = 38
    let ballRadius:CGFloat = 14
    
    let field:Field
    
    let ball:UIView = {
        $0.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        return $0
    }(UIView())
    
    var players:[Player:UIView] = [:]
    
    init(view: UIView) {
        self.view = view
        ball.frame = CGRect(origin: CGPoint.zero, size:CGSize(width: ballRadius, height: ballRadius))
        ball.layer.cornerRadius = ballRadius/2
        field = Field(size: view.bounds.size, adjustment: 0)
    }
    
    mutating func play(play: Play) {
        
        guard let homeTeam = play.homeTeam else {
            return
        }
        
        wipeClean()
        
        for player in homeTeam.players {
            registerPlayer(player, initialPosition: player.initialPosition())
        }
    }
    
    mutating func registerPlayer(_ player:Player, initialPosition:Coordinate) {
        
        let playerView = playerCircle(coordinate: initialPosition, number: String(player.number), alpha: 1)
        players[player] = playerView
        view.addSubview(playerView)
    }
    
    func animate(play: Play) {
        
        /*guard let initialCoord = play.players.first?.position.first,
            let lastCoord = play.players.last?.position.last else {
                print("NO DATA")
                return
        }
        
        print("Initial Coord: \(initialCoord)")
        print("Last Coord: \(lastCoord)")
        */
        /*ball.center = Field.dribbleBallPosition(p1: initialPosition, p2: lastPosition)
        view.addSubview(ball)
        
        let ballMovement = CABasicAnimation(keyPath: "position")
        ballMovement.fromValue = ball.center
        ballMovement.toValue = lastPosition
        ballMovement.duration = 1
        ballMovement.repeatCount = 1
        ballMovement.isRemovedOnCompletion = false
        ballMovement.fillMode = kCAFillModeForwards
        ball.layer.add(ballMovement, forKey: nil)
        
        let totalDuration = play.animationDuration
        
        // Position array conversion
        var converted = [Int: [Player:String]]()
        
        play.homeTeam.players().forEach { player, value in
            
            for (timestamp, position) in value {
                converted[timestamp]?[player] = position
            }
        }
        
        // Actual animation
        for step in converted.keys {
            
            guard let players = converted[step] else {
                return
            }
            
            for player in players {
                
            }
        }*/
        
        for player in play.homeTeam!.players {
            
            guard let playerView = players[player] else {
                continue
            }
            
            chainedAnimations(view: playerView, offset: player.positions(skipInitial:true).map { field.calculatePoint(coordinate: $0.position) })
        }
    }
    
    // MARK: - Private methods
    private func chainedAnimations(view:UIView, offset:[CGPoint]) -> () {
        
        guard let amount = offset.last else {
            return
        }
                
        return UIView.animate(withDuration: 3,
                              delay: 0,
                              options: [.curveLinear],
                              animations: {
            view.center.x = CGFloat(amount.x)
            view.center.y = CGFloat(amount.y)
        }, completion: {
            
            (finished: Bool) in
            
            guard offset.count > 0 else {
                return
            }
            
            self.chainedAnimations(view: view, offset: Array(offset[0..<offset.count-1]))
        })
    }
    
    private func playerCircle(coordinate:Coordinate, number:String, alpha:Double = 1.0) -> UIView {
        
        // calculate position
        let point = field.calculatePoint(coordinate: coordinate)
        
        // draw red circle
        let playerView:UILabel = {
            $0.frame = CGRect(x: point.x, y: point.y, width:playerRadius, height: playerRadius)
            $0.backgroundColor = UIColor.red
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
            $0.layer.borderWidth = 1.0
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.cornerRadius = playerRadius / 2.0
            $0.text = number
            $0.alpha = CGFloat(alpha)
            return $0
        }(UILabel())
        
        return playerView
    }
    
    private func run(coordinateStart:Coordinate, coordinateEnd:Coordinate) -> CAShapeLayer {
        return line(coordinateStart: coordinateStart, coordinateEnd: coordinateEnd, type: Line.run)
    }
    
    private func pass(coordinateStart:Coordinate, _ coordinateEnd:Coordinate) -> CAShapeLayer {
        return line(coordinateStart: coordinateStart, coordinateEnd: coordinateEnd, type: Line.pass)
    }
    
    private func line(coordinateStart:Coordinate, coordinateEnd:Coordinate, type:Line) -> CAShapeLayer {
        
        let size = Double(view.bounds.size.height / 12.0 * 0.6)
        let adjustment = CGFloat(size)/2.0
        
        let point1 = field.calculatePoint(coordinate: coordinateStart)
        let point2 = field.calculatePoint(coordinate: coordinateEnd)
        
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
