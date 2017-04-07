//: Playground - noun: a place where people can play
import UIKit
import PlaygroundSupport

let bg = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
bg.backgroundColor = .white
PlaygroundPage.current.liveView = bg
/*
let square = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
square.backgroundColor = .red
square.center = bg.center
bg.addSubview(square)



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


let label:UILabel = {
    $0.frame = CGRect(x: 0, y: 0, width:100, height: 100)
    $0.text = "lol"
    $0.textColor = UIColor.white
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 50.0, weight: UIFontWeightBold)
    return $0
}(UILabel())
*/


let label:UILabel = {
    $0.frame = CGRect(x:0, y:0, width:200, height:21)
    $0.text = "lol"
    $0.textColor = UIColor.red
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 50.0, weight: UIFontWeightBold)
    return $0
}(UILabel())

bg.addSubview(label)

/*
let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:21))
//label.center = CGPointMake(160, 284)
label.textAlignment = NSTextAlignment.center
label.text = "I'am a test label"
bg.addSubview(label)





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
*/