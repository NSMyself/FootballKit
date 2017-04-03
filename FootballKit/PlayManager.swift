//
//  PlayManager.swift
//  FootballKit
//
//  Created by João Pereira on 13/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit
import EasyAnimation

class PlayManager {
    
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
        field = Field(size: view.bounds.size, adjustment: CGSize(width: 14, height: 16))
    }
    
    func play(play: Play) {
        
        guard let homeTeam = play.homeTeam else {
            return
        }
        
        wipeClean()
        
        for player in homeTeam.players {
            registerPlayer(player, initialPosition: player.initialPosition())
        }
        
        if let player = play.initialBallCarrier {
            drawBall(with: player)
        }
    }
    
    func registerPlayer(_ player:Player, initialPosition:Coordinate) {
        let playerView = playerCircle(coordinate: initialPosition, number: String(player.number), alpha: 1)
        players[player] = playerView
        view.addSubview(playerView)
    }
    
    
    func drawBall(with player:Player) {
        
        guard let playerView = players[player] else {
            return
        }
        
        let nextPoint = field.calculatePoint(coordinate: .H7)
        
        self.ball.center = self.periferalBallPosition(from:playerView.center, to:nextPoint)
        
        //ball.center.x = playerView.center.x - ballRadius*2
        //ball.center.y = playerView.center.y
        view.addSubview(ball)
        print("Ball: \(ball.center)")
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
            
            animate(view: playerView, actions: player.actions)
        }
    }
    
    // MARK: - Private methods
    private func animate(view player:UIView, actions:Queue<Action>) -> () {
        
        func fetchNextAction(from actions:Queue<Action>) {
            
            func handle(action: Action) {
                
                switch(action) {
                case is Movement:
                    move(to: action.destination, duration:action.duration)
                case is BallAction:
                    print("Player did something to the ball")
                case is Hold:
                    print("Nothing to do but wait")
                default:
                    print("Unknown action! Terminating")
                }
            }
            
            var remainingActions = actions
            
            guard let next = remainingActions.dequeue() else {
                return
            }
            
            handle(action: next)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + next.duration) {
                fetchNextAction(from: remainingActions)
            }
        }
        
        func move(to:Coordinate, duration:Double) {
            
            print("Moving")
            
            let converted = field.calculatePoint(coordinate: to)
            
            UIView.animate(withDuration: duration,
                          delay: 0,
                          options: [.curveLinear],
                          animations: {
                            [unowned self] in
                            self.ball.center = self.periferalBallPosition(from:player.center , to:converted)
                            player.center = converted
                            
            }, completion: { _ in
                print(player.frame)
                print(self.ball.frame)
            })
        }

        var animatedActions = actions
        
         // dropping the first action due to the fact it only represents the initial position of the player
        guard let original = animatedActions.dequeue() else {
            return
        }
        
        /*let converted = field.calculatePoint(coordinate: original.destination)
        player.center = CGPoint(x: converted.x, y: converted.y)
        
        self.ball.center.x = player.center.x - ballRadius*2
        self.ball.center.y = player.center.y
        */
        fetchNextAction(from: animatedActions)
    }
    
    
    private func periferalBallPosition(from:CGPoint, to:CGPoint)->CGPoint {
        let theta = atan2((to.y - from.y), (to.x-from.y))
        print("Angle is \(theta)")
        
        let y = playerRadius * sin(theta)
        let x = playerRadius * cos(theta)
        
        print("position is \(x) - \(y)")
        
        return CGPoint(x: from.x + x + ballRadius, y: from.y + y)
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
    
    
    // MARK: - Drawables (solid and dotted lines for passes and runs, respectively)
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
