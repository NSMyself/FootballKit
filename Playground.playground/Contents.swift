//: Playground - noun: a place where people can play
import UIKit
import PlaygroundSupport

let bg = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
bg.backgroundColor = .white
PlaygroundPage.current.liveView = bg

let square = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
square.backgroundColor = .red
square.center = bg.center
bg.addSubview(square)


/*
// Chainable animations
typealias Position = (x: Int, y: Int)

let movements:[Position] = [(x:100, y:0), (x:-200, y:100), (x:15, y:-200)]

func gleipnir(offset:[Position]) -> () {
    
    guard let amount = offset.last else {
        return
    }
    
    print("Amount: \(amount)")
    
    return UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear],
                          animations: {
        square.center.x += CGFloat(amount.x)
        square.center.y += CGFloat(amount.y)
    }, completion: {
        
        (finished: Bool) in
        
        guard offset.count > 0 else {
            return
        }
        
        gleipnir(offset: Array(offset[0..<offset.count-1]))
    })
}

//gleipnir(offset: movements)
*/
let start = square.center
let end = CGPoint(x:200, y:400)

let animation = CAKeyframeAnimation(keyPath: "position")
let path = UIBezierPath()
path.move(to: square.center)

let c1 = CGPoint(x:start.x + 64, y:start.y)
let c2 = CGPoint(x:end.x, y: end.y)

path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
animation.path = path.cgPath
animation.fillMode = kCAFillModeForwards
animation.isRemovedOnCompletion = false
animation.duration = 3

//square.layer.add(animation, forKey: "movement")

let animation2 = CAKeyframeAnimation(keyPath: "transform.scale")
animation2.values = [1,2,1].map { NSNumber(value: $0) }
animation2.duration = 1

square.layer.add(animation2, forKey: "transform")
