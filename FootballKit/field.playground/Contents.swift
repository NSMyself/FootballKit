import UIKit
import PlaygroundSupport

let fieldSize = CGSize(width: 575, height: 400)
let realSize = CGSize(width: 105, height: 75)
let offsets = CGSize(width: 19, height: 19)

enum Line {
    case vertical
    case horizontal
}

func add(line:Line, at origin:CGPoint, color:UIColor = UIColor.orange) -> UIView {
    
    let view = UIView()
    view.backgroundColor = UIColor.orange
    view.frame.origin = origin
    view.frame.size = line == .vertical ? CGSize(width: 1, height: fieldSize.height) : CGSize(width: fieldSize.width, height: 1)
    return view
}

let background:UIView = {
    $0.frame = CGRect(origin: .zero, size: fieldSize)
    $0.backgroundColor = UIColor(red: 68/255, green: 123/255, blue: 22/255, alpha: 1)
    return $0
}(UIView())

PlaygroundPage.current.liveView = background

func calculateProportion(width:CGFloat, height:CGFloat)->CGSize {
    let bWidth = (fieldSize.width - offsets.width * 2) * width / realSize.width
    let bHeight = (fieldSize.height - offsets.height * 2) * height / realSize.height

    return CGSize(width: bWidth, height: bHeight)
}


////////////////////////////////////////////////

let field:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: offsets.width, y:offsets.height), size: CGSize(width: fieldSize.width - offsets.width*2, height: fieldSize.height - offsets.height*2))
    $0.backgroundColor = UIColor(red: 85/255, green: 149/255, blue: 30/255, alpha: 1)
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())

background.addSubview(field)

// Draw vertical lanes
var tracker = offsets.width + fieldSize.width/15

for i in 0...6 {
    
    let xWidth:CGFloat = (i == 6) ? fieldSize.width/15 - 2 : fieldSize.width/15
    
    let faixa:UIView = {
        $0.frame = CGRect(origin: CGPoint(x: tracker, y:offsets.height + 2), size: CGSize(width: xWidth, height: fieldSize.height - offsets.height*2 - 4))
        $0.backgroundColor = UIColor(red: 93/255, green: 162/255, blue: 36/255, alpha: 1)
        return $0
    }(UIView())
    background.addSubview(faixa)
    
    tracker += fieldSize.width/15*2
}

// Center lines
let halfway:UIView = {
    $0.frame = CGRect(origin:.zero, size: CGSize(width: 2, height: fieldSize.height-offsets.height*2-4))
    $0.center = background.center
    $0.backgroundColor = UIColor.white
    return $0
}(UIView())
background.addSubview(halfway)

let diameter = (fieldSize.width - offsets.width * 2) * 9.15 * 2 / realSize.width
print(diameter)

let centerSpot:UIView = {
    $0.frame = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
    $0.center = background.center
    $0.layer.cornerRadius = diameter/2
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())
background.addSubview(centerSpot)

let centerCircle:UIView = {
    $0.frame = CGRect(origin: .zero, size: CGSize(width: 6, height: 6))
    $0.center = background.center
    $0.layer.cornerRadius = 3
    $0.backgroundColor = UIColor.white
    return $0
}(UIView())
background.addSubview(centerCircle)

// Penalty boxes

let boxSize = calculateProportion(width: 16.5, height: 40.3)

let penaltyBox1:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: offsets.width, y:0), size: CGSize(width: boxSize.width, height: boxSize.height))
    $0.center = CGPoint(x: $0.center.x, y: background.center.y)
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())


let innerSize = calculateProportion(width: 5.5, height: 16.5)

let innerBox1:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: 0, y:(boxSize.height - innerSize.height)/2), size: CGSize(width: innerSize.width, height: innerSize.height))
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())

penaltyBox1.addSubview(innerBox1)

let tmp = (fieldSize.width - offsets.width * 2) * 11 / realSize.width
print(tmp)

let spot:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: innerBox1.frame.maxX * 2 - 6, y: boxSize.height/2 - 3), size: CGSize(width: 6, height: 6))
    $0.layer.cornerRadius = 3
    $0.backgroundColor = UIColor.white
    return $0
}(UIView())

penaltyBox1.addSubview(spot)

let penaltyBox2:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: fieldSize.width - offsets.width - boxSize.width, y:0), size: CGSize(width: boxSize.width, height: boxSize.height))
    $0.center = CGPoint(x: $0.center.x, y: background.center.y)
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())

let innerBox2:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: penaltyBox2.frame.width - innerSize.width, y:(boxSize.height - innerSize.height)/2), size: CGSize(width: innerSize.width, height: innerSize.height))
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 2
    return $0
}(UIView())

penaltyBox2.addSubview(innerBox2)

let spot2:UIView = {
    $0.frame = CGRect(origin: CGPoint(x: penaltyBox2.frame.width - tmp, y: boxSize.height/2 - 3), size: CGSize(width: 6, height: 6))
    $0.layer.cornerRadius = 3
    $0.backgroundColor = UIColor.white
    return $0
}(UIView())

penaltyBox2.addSubview(spot2)

background.addSubview(penaltyBox1)
background.addSubview(penaltyBox2)












