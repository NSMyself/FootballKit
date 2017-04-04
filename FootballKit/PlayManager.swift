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
    let swerveOffset:CGFloat = 70
    
    let field:Field
    
    let ball:UIView = {
        $0.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        return $0
    }(UIView())
    
    var players:[Player:UIView] = [:]
    
    var ballCarrier:Player?
    
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
            registerPlayer(player, initialPosition: player.tracker.initialPosition() ?? .G6)
        }
        
        if let player = play.initialBallCarrier {
            drawBall(with: player)
            ballCarrier = player
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
        
        ball.center = aimBall(from:playerView.center, to:field.calculatePoint(coordinate: .A4))
        print(ball.center)
        view.addSubview(ball)
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
            
            animate(player: player, view: playerView, actions: player.actions)
        }
    }
    
    // MARK: - Private methods
    private func animate(player:Player, view:UIView, actions:Queue<Action>) -> () {
        
        func fetchNextAction(from actions:Queue<Action>) {
            
            func handle(action: Action) {
                
                switch(action) {
                case is Movement:
                    move(player:player, to: action.destination, duration:action.duration)
                case is BallAction:
                    let ballAction = action as! BallAction
                    pass(player:player, to: field.calculatePoint(coordinate: action.destination), duration: ballAction.duration, swerve: ballAction.swerve)
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
        
        func move(player:Player, to:Coordinate, duration:Double) {
            
            print("Moving")
            
            let converted = field.calculatePoint(coordinate: to)
            
            UIView.animate(withDuration: duration,
                          delay: 0,
                          options: [.curveLinear],
                          animations: {
                            [unowned self] in
                            
                            if (self.ballCarrier == player) {
                                let diferential = (self.ball.center.x - view.center.x, self.ball.center.y - view.center.y)
                                self.ball.center = self.moveWithBall(to: converted, maintaining: diferential)
                            }
                            else {
                                print("This guy doesn't have the ball")
                            }
                            
                            view.center = converted
                }, completion: nil)
        }
        
        func pass(player:Player, to:CGPoint, duration:Double = 2, swerve:Swerve? = nil) {
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [.curveLinear],
                           animations: {
                            
                            [unowned self] in
                            
                            guard let lastCoordinate = player.tracker.lastPosition() else {
                                return
                            }
                            
                            let from = self.field.calculatePoint(coordinate: lastCoordinate)

                            // Time to animate it
                            let animation = CAKeyframeAnimation(keyPath: "position")
                            let path = UIBezierPath()
                            path.move(to: from)

                            if let swerveFactor = swerve {
                                let c1 = CGPoint(x:from.x + self.swerveOffset * CGFloat(swerveFactor.rawValue), y:from.y)
                                let c2 = CGPoint(x:to.x, y: to.y)
                                
                                path.addCurve(to: to, controlPoint1: c1, controlPoint2: c2)
                                animation.duration = duration
                            }
                            else {
                                path.addLine(to: to)
                                animation.duration = 0.2
                            }
                            
                            animation.path = path.cgPath
                            animation.fillMode = kCAFillModeForwards
                            animation.isRemovedOnCompletion = false
                            self.ball.layer.add(animation, forKey:nil)
                }, completion: { _ in
                    print("Just passed the ball")
                    
                    for player in self.players {
                        if player.value.center == to {
                            print("É PRA ESTE! \(player.key.name)")
                            self.ballCarrier = player.key
                        }
                    }
            })
        }

        fetchNextAction(from: actions)
    }
    
    private func aimBall(from:CGPoint, to:CGPoint)->CGPoint {
        let theta = atan2((to.y - from.y), (to.x-from.y))
        let y = playerRadius * sin(theta)
        let x = playerRadius * cos(theta)
        return CGPoint(x: from.x + x + ballRadius, y: from.y + y)
    }
    
    private func moveWithBall(to:CGPoint, maintaining:(x: CGFloat, y: CGFloat)) -> CGPoint {
        return CGPoint(x: to.x + maintaining.y, y:to.y + maintaining.y)
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
    
    
    /*// MARK: - Drawables (solid and dotted lines for passes and runs, respectively)
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
    }*/
    
    private func wipeClean() {
        
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        view.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
}
