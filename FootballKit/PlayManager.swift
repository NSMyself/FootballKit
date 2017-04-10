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
    
    var isAnimating = false
    
    let ball:UIView = {
        $0.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        $0.isOpaque = true
        return $0
    }(UIView())
    
    var players:[Player:UIView] = [:]
    var ballCarrier:Player?
    
    weak var delegate:PlayManagerDelegate?
    
    init(view: UIView, delegate:PlayManagerDelegate? = nil) {
        self.view = view
        ball.frame = CGRect(origin: CGPoint.zero, size:CGSize(width: ballRadius, height: ballRadius))
        ball.layer.cornerRadius = ballRadius/2
        field = Field(size: view.bounds.size, adjustment: CGSize(width: 14, height: 16))
        
        self.delegate = delegate
    }
    
    func play(play: Play) {
        
        wipeClean()
        
        for player in play.allPlayers {
            registerPlayer(player, initialPosition: player.tracker.initialPosition())
            
            if player == play.initialBallCarrier {
                resetBall(with: player)
            }
        }
    }
    
    func registerPlayer(_ player:Player, initialPosition:Coordinate) {
        
        let color = player.team?.color ?? UIColor.red
        
        let playerView = playerCircle(coordinate: initialPosition, player: player, color: color)
        players[player] = playerView
        view.addSubview(playerView)
    }
    
    func resetPlayers(in play:Play) {
        for player in players {
            player.value.frame.origin = field.point(from: player.key.tracker.initialPosition())
         
            if player.key == play.initialBallCarrier {
                resetBall(with: player.key)
            }
        }
    }
    
    func resetBall(with player:Player) {
        
        guard let playerView = players[player] else {
            return
        }
        
        ball.center = aimBall(from:playerView.center, to:field.point(from: .A4))
        view.addSubview(ball)
        
        ballCarrier = player
    }
    
    func animate(_ play: Play) {
        
        guard (!isAnimating) else {
            return
        }
        
        // The player may not be registered
        // As such, we're using this method to make sure he was indeed registered before firing the delegation animationStarted() method
        func notifyAnimationStart() {
            guard !isAnimating else {
                return
            }
         
            isAnimating = true
            delegate?.animationDidStart()
        }
        
        resetPlayers(in:play)
        
        let group = DispatchGroup()
    
        for player in play.allPlayers {
            
            guard let playerView = players[player] else {
                continue
            }

            notifyAnimationStart()
            group.enter()
            animate(player: player, view: playerView, actions: player.actions) {
                group.leave()
            }
        }
     
        group.notify(qos: DispatchQoS.background, flags: .assignCurrentContext, queue: DispatchQueue.main) {
            self.isAnimating = false
            self.delegate?.animationDidStop()
        }
    }
    
    // MARK: - Private methods
    private func animate(player:Player, view:UIView, actions:Queue<Action>, completion:@escaping ()->()) -> () {
        
        func fetchNextAction(from actions:Queue<Action>) {
            
            func handle(action: Action) {
                
                switch(action) {
                case is Movement:
                    move(player:player, to: action.destination, duration:action.duration)
                case is BallAction:
                    let ballAction = action as! BallAction
                    
                    // For now, every shot is a goal
                    // TODO: implement a proper result for each shot (blocked; missed; etc)
                    let goal = (ballAction.kind == .shoot)
                    
                    kickBall(player:player, to: field.point(from: action.destination), duration: ballAction.duration, swerve: ballAction.swerve, highBall: ballAction.highBall, scored:goal)
                case is Hold:
                    print("Nothing to do but wait")
                default:
                    print("Unknown action! Terminating")
                }
            }
            
            var remainingActions = actions
            
            guard let next = remainingActions.dequeue() else {
                completion()
                return
            }
            
            handle(action: next)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + next.duration) {
                fetchNextAction(from: remainingActions)
            }
        }
        
        func move(player:Player, to coordinate:Coordinate, duration:Double) {
                        
            let converted = field.point(from: coordinate)
            
            UIView.animate(withDuration: duration,
                          delay: 0,
                          options: [.curveLinear],
                          animations: {
                            [unowned self] in
                            
                            if (self.ballCarrier == player) {
                                let diferential = (self.ball.center.x - view.center.x, self.ball.center.y - view.center.y)
                                self.ball.center = self.moveWithBall(to: converted, maintaining: diferential)
                            }
                            
                            view.center = converted
                }, completion: nil)
        }
        
        func kickBall(player:Player, to:CGPoint, duration:Double = 2, swerve:Swerve? = nil, highBall:Bool = false, scored:Bool = false) {
            
            guard let lastCoordinate = player.tracker.lastPosition() else {
                return
            }
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                if scored {
                    self.delegate?.scored(player: player)
                }
            })
            
            let from = self.field.point(from: lastCoordinate)

            // Time to animate it
            let animation = CAKeyframeAnimation(keyPath: "position")
            let path = UIBezierPath()
            path.move(to: from)

            if let swerve = swerve {
                let c1 = CGPoint(x:from.x + CGFloat(swerve.factor * swerve.direction.rawValue), y:from.y)
                let c2 = CGPoint(x:to.x, y: to.y)
                path.addCurve(to: to, controlPoint1: c1, controlPoint2: c2)
            }
            else {
                path.addLine(to: to)
            }
            
            if highBall {
                let scaleAnim = CAKeyframeAnimation(keyPath:"transform.scale")
                scaleAnim.values = [1, 1.2, 1.4, 2, 1.4, 1.2,1].map { NSNumber(value: $0) }
                scaleAnim.duration = duration
                
                self.ball.layer.add(scaleAnim, forKey: "transform")
            }
            
            animation.duration = duration
            animation.path = path.cgPath
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            self.ball.layer.add(animation, forKey:nil)
            
            CATransaction.commit()
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

    private func playerCircle(coordinate:Coordinate, player:Player, color:UIColor, textColor:UIColor = UIColor.white) -> UIView {
        
        // calculate position
        let point = field.point(from: coordinate)
        
        // draw red circle
        let playerView:UIView = {
            $0.frame = CGRect(x: point.x, y: point.y, width:playerRadius, height: playerRadius)
            $0.backgroundColor = color
            $0.layer.borderWidth = 1.0
            $0.layer.masksToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.borderColor = color.cgColor
            $0.layer.cornerRadius = playerRadius / 2.0
            $0.isOpaque = true
            $0.isUserInteractionEnabled = true
            return $0
        }(UIView())
     
        let label:UILabel = {
            $0.frame = CGRect(x: 0, y: 0, width:playerRadius, height: playerRadius)
            $0.text = String(player.number)
            $0.textColor = textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
            return $0
        }(UILabel())
        
        playerView.addSubview(label)
        return playerView
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
