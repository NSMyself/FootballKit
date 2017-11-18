//
//  FieldManager.swift
//  FootballKit
//
//  Created by João Pereira on 09/11/2017.
//  Copyright © 2017 nsmyself. All rights reserved.
//

import Foundation
import UIKit

struct FieldManager {
    
    static let realSize = CGSize(width: 105, height: 75)
    static let offsets = CGSize(width: 19, height: 19)
    
    enum Line {
        case vertical
        case horizontal
    }
    
    static func add(line:Line, at origin: CGPoint, amount: CGFloat, color: UIColor = .orange) -> UIView {
        
        return {
            $0.frame.origin = origin
            $0.frame.size = line == .vertical ? CGSize(width: 1, height: amount) : CGSize(width: amount, height: 1)
            $0.backgroundColor = UIColor.orange
            return $0
            }(UIView())
    }
    
    static func calculateProportion(of fieldSize: CGSize, width: CGFloat, height: CGFloat) -> CGSize {
        let bWidth = (fieldSize.width - offsets.width * 2) * width / realSize.width
        let bHeight = (fieldSize.height - offsets.height * 2) * height / realSize.height
        
        return CGSize(width: bWidth, height: bHeight)
    }
    
    static func render(using fieldSize: CGSize) -> UIView {
        
        let background: UIView = {
            $0.frame = CGRect(origin: .zero, size: fieldSize)
            $0.backgroundColor = UIColor(red: 68/255, green: 123/255, blue: 22/255, alpha: 1)
            return $0
        }(UIView())
        
        let field: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: offsets.width, y:offsets.height), size: CGSize(width: fieldSize.width - offsets.width*2, height: fieldSize.height - offsets.height*2))
            $0.backgroundColor = UIColor(red: 85/255, green: 149/255, blue: 30/255, alpha: 1)
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            $0.clipsToBounds = true
            return $0
        }(UIView())
        
        background.addSubview(field)
        
        // Draw vertical lanes
        var tracker = fieldSize.width/15
        
        for i in 0...6 {
            
            let xWidth:CGFloat = (i == 6) ? fieldSize.width/15 - 2 : fieldSize.width/15
            
            let faixa: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: tracker, y:0), size: CGSize(width: xWidth, height: fieldSize.height - offsets.height*2 - 4))
            $0.backgroundColor = UIColor(red: 93/255, green: 162/255, blue: 36/255, alpha: 1)
            return $0
            }(UIView())
            
            field.addSubview(faixa)
            tracker += fieldSize.width/15*2
        }
        
        // Center lines
        let halfway: UIView = {
            $0.frame = CGRect(origin:.zero, size: CGSize(width: 2, height: fieldSize.height-offsets.height*2-4))
            $0.center = background.center
            $0.backgroundColor = UIColor.white
            return $0
        }(UIView())
        background.addSubview(halfway)
        
        let diameter = (fieldSize.width - offsets.width * 2) * 9.15 * 2 / realSize.width
        print(diameter)
        
        let centerSpot: UIView = {
            $0.frame = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
            $0.center = background.center
            $0.layer.cornerRadius = diameter/2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            return $0
        }(UIView())
        background.addSubview(centerSpot)
        
        let centerCircle: UIView = {
            $0.frame = CGRect(origin: .zero, size: CGSize(width: 6, height: 6))
            $0.center = background.center
            $0.layer.cornerRadius = 3
            $0.backgroundColor = UIColor.white
            return $0
        }(UIView())
        background.addSubview(centerCircle)
        
        let circleDiameter = ((fieldSize.width - offsets.width * 2) * 2 / realSize.width) * 2
        
        let cornerCircle1: UIView = {
            $0.frame = CGRect(origin: .zero, size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.center = .zero
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle1)
        
        let cornerCircle2: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: field.frame.width - circleDiameter/2, y: -circleDiameter/2), size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle2)
        
        let cornerCircle3: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: field.frame.width - circleDiameter/2, y: field.frame.height - circleDiameter/2), size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle3)
        
        let cornerCircle4: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: -circleDiameter/2, y: field.frame.height - circleDiameter/2), size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle4)
        
        // Penalty boxes
        let boxSize = calculateProportion(of: fieldSize, width: 16.5, height: 40.3)
        
        let penaltyBox1: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: offsets.width, y:0), size: CGSize(width: boxSize.width, height: boxSize.height))
            $0.center = CGPoint(x: $0.center.x, y: background.center.y)
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            return $0
        }(UIView())
        
        let innerSize = calculateProportion(of: fieldSize, width: 5.5, height: 16.5)
        
        let innerBox1: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: 0, y:(boxSize.height - innerSize.height)/2), size: CGSize(width: innerSize.width, height: innerSize.height))
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            return $0
        }(UIView())
        
        penaltyBox1.addSubview(innerBox1)
        
        let tmp = (fieldSize.width - offsets.width * 2) * 11 / realSize.width
        
        let spot: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: innerBox1.frame.maxX * 2 - 6, y: boxSize.height/2 - 3), size: CGSize(width: 6, height: 6))
            $0.layer.cornerRadius = 3
            $0.backgroundColor = UIColor.white
            return $0
        }(UIView())
        
        penaltyBox1.addSubview(spot)
        
        let penaltyBox2: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: fieldSize.width - offsets.width - boxSize.width, y:0), size: CGSize(width: boxSize.width, height: boxSize.height))
            $0.center = CGPoint(x: $0.center.x, y: background.center.y)
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            return $0
        }(UIView())
        
        let innerBox2: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: penaltyBox2.frame.width - innerSize.width, y:(boxSize.height - innerSize.height)/2), size: CGSize(width: innerSize.width, height: innerSize.height))
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2
            return $0
        }(UIView())
        
        penaltyBox2.addSubview(innerBox2)
        
        let spot2: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: penaltyBox2.frame.width - tmp, y: boxSize.height/2 - 3), size: CGSize(width: 6, height: 6))
            $0.layer.cornerRadius = 3
            $0.backgroundColor = UIColor.white
            return $0
        }(UIView())
        
        penaltyBox2.addSubview(spot2)
        
        background.addSubview(penaltyBox1)
        background.addSubview(penaltyBox2)
        
        // Grid
        var spacing:CGFloat = offsets.height
        let xIncrement = fieldSize.height / 11
        
        // Horizontal lines
        for x in 1...10 {
        
            let line: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: offsets.width - 10, y: spacing), size: CGSize(width:field.frame.width + 20, height:1))
            $0.backgroundColor = UIColor.yellow
            return $0
            }(UIView())
            
            let label: UILabel = {
            $0.text = String(x)
            $0.textColor = .yellow
            $0.textAlignment = .right
            $0.frame.size = CGSize(width:28, height: 14)
            $0.center = CGPoint(x: 0, y: spacing + xIncrement/2)
            return $0
            }(UILabel())
            
            background.addSubview(line)
            background.addSubview(label)
            
            spacing += xIncrement
        }
        
        let yColumns: CGFloat = 15
        let yIncrement = fieldSize.width/yColumns
        
        var yTracker = offsets.width
        
        for y in "ABCDEFGHIJKLMN" {
            let line: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: yTracker, y: offsets.height - 10), size: CGSize(width:1, height:fieldSize.height + 10))
            $0.backgroundColor = UIColor.yellow
            return $0
            }(UIView())
            
            let label: UILabel = {
            $0.text = String(y)
            $0.textColor = UIColor.yellow
            $0.textAlignment = .center
            $0.frame.size = CGSize(width:28, height: 14)
            $0.center = CGPoint(x: yTracker + yIncrement/2, y: offsets.height - 10)
            return $0
            }(UILabel())
            
            background.addSubview(line)
            background.addSubview(label)
            
            yTracker += yIncrement
        }
        
        return background
    }
}
