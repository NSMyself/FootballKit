//
//  FieldManager.swift
//  FootballKit
//
//  Created by João Pereira on 09/11/2017.
//  Copyright © 2017 nsmyself. All rights reserved.
//

import Foundation
import UIKit

class FieldManager {

    static let firstGoal: Coordinate = .A6
    static let secondGoal: Coordinate = .R6
    
    var offsets = CGSize(width: 20, height: 20)
    
    private let nColumns: CGFloat = 14
    private let nRows: CGFloat = 10
    
    public var containerBackgroundColor = UIColor(red: 68/255, green: 123/255, blue: 22/255, alpha: 1)
    public var fieldBackgroundColor = UIColor(red: 85/255, green: 149/255, blue: 30/255, alpha: 1)
    public var fieldAlternativeColor = UIColor(red: 93/255, green: 162/255, blue: 36/255, alpha: 1)
    public var indicatorLineColor = UIColor.yellow
    public var indicatorLabelColor = UIColor.yellow
    
    private var indicatorSpacing: CGFloat = 10
    
    // MARK: - Actual field generation
    func generate(viewSize fieldSize: CGSize, padding: CGSize = .zero) -> UIView {
        
        offsets = padding
        
        let background: UIView = {
            $0.frame = CGRect(origin: .zero, size: fieldSize)
            $0.backgroundColor = containerBackgroundColor
            return $0
        }(UIView())
        
        let field: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: offsets.width, y: offsets.height), size: CGSize(width: fieldSize.width - offsets.width*2, height: fieldSize.height - offsets.height*2))
            $0.backgroundColor = fieldBackgroundColor
            $0.clipsToBounds = true
            return $0
        }(UIView())
        
        let markings = UIView()
        markings.frame = field.frame
        background.addSubview(field)
        background.addSubview(markings)
        
        // Center lines
        let halfway: UIView = {
            $0.frame = CGRect(origin:.zero, size: CGSize(width: 2, height: fieldSize.height-offsets.height*2-4))
            $0.center = background.center
            $0.backgroundColor = UIColor.white
            return $0
        }(UIView())
        background.addSubview(halfway)
        
        let diameter = (fieldSize.width - offsets.width * 2) * 9.15 * 2
        
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
        
        let circleDiameter = ((fieldSize.width - offsets.width * 2) * 2) * 2
        
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
            $0.backgroundColor = .clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle2)
        
        let cornerCircle3: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: field.frame.width - circleDiameter/2, y: field.frame.height - circleDiameter/2), size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .clear
            return $0
        }(UIView())
        field.addSubview(cornerCircle3)
        
        let cornerCircle4: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: -circleDiameter/2, y: field.frame.height - circleDiameter/2), size: CGSize(width: circleDiameter, height: circleDiameter))
            $0.layer.cornerRadius = circleDiameter/2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .clear
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
        
        let tmp = (fieldSize.width - offsets.width * 2) * 11
        
        let spot: UIView = {
            $0.frame = CGRect(origin: CGPoint(x: innerBox1.frame.maxX * 2 - 6, y: boxSize.height/2 - 3), size: CGSize(width: 6, height: 6))
            $0.layer.cornerRadius = 3
            $0.backgroundColor = .white
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
            $0.backgroundColor = .white
            return $0
        }(UIView())
        
        penaltyBox2.addSubview(spot2)
        
        background.addSubview(penaltyBox1)
        background.addSubview(penaltyBox2)
 
        // Grid
        let yIncrement = (fieldSize.height - offsets.height * 2) / 10
        
        // Columns
        // Draw different color grass lane (lighter green)
        let xIncrement = (fieldSize.width - offsets.width*2)/nColumns
        
        var tracker: CGFloat = 0
        
        for _ in 0...6 {
            let lane: UIView = {
                $0.frame = CGRect(origin: CGPoint(x: tracker, y: 0),
                                  size: CGSize(width: xIncrement, height: fieldSize.height - offsets.height*2))
                $0.backgroundColor = fieldAlternativeColor
                return $0
            }(UIView())
            
            markings.addSubview(lane)
            tracker += xIncrement * 2
        }
        
        // Draw indicators
        tracker = 0
        
        for y in "ABCDEFGHIJKLMNO" {
            
            let line: UIView = {
                $0.frame = CGRect(origin: CGPoint(x: tracker, y: -10),
                                  size: CGSize(width: 1, height: field.frame.height + 20))
                $0.backgroundColor = indicatorLineColor
                return $0
            }(UIView())
            
            markings.addSubview(line)
            
            if y != "O" {
                let label: UILabel = {
                    $0.text = String(y)
                    $0.textColor = .yellow
                    $0.textAlignment = .center
                    $0.sizeToFit()
                    $0.center = CGPoint(x: tracker + xIncrement/2, y: -15)
                    return $0
                }(UILabel())
                
                markings.addSubview(label)
            }
            
            tracker += xIncrement
        }
        
        // Lines
        tracker = 0
        
        for x in 1...11 {
            
            let line: UIView = {
                $0.frame = CGRect(origin: CGPoint(x: -10, y: tracker), size: CGSize(width: markings.frame.width + 20, height:1))
                $0.backgroundColor = indicatorLineColor
                return $0
            }(UIView())
            
            markings.addSubview(line)
            
            if x < 11 {
                let label: UILabel = {
                    $0.text = String(x)
                    $0.textColor = indicatorLabelColor
                    $0.textAlignment = .right
                    $0.sizeToFit()
                    $0.center = CGPoint(x: -offsets.width / 2, y: tracker + yIncrement/2)
                    return $0
                }(UILabel())
                
                markings.addSubview(label)
            }
            
            tracker += yIncrement
        }
        
        
        return background
    }
    
    // MARK: - Auxiliar methods
    private func add(line: LineMarking, at origin: CGPoint, amount: CGFloat, color: UIColor = .orange) -> UIView {
        return {
            $0.frame.origin = origin
            $0.frame.size = line.size(considering: amount)
            $0.backgroundColor = UIColor.orange
            return $0
            }(UIView())
    }
    
    func point(from coordinate: Coordinate) -> CGPoint {
        let squareSize = CGSize(width: 150, height: 150)
        let squareOffset = CGPoint(x: squareSize.width / 2.0, y: squareSize.height / 2.0)
        
        let x = squareSize.width * CGFloat(Double(coordinate.x) - 1.0) + squareOffset.x * 1.3
        let y = squareSize.height * CGFloat(Double(coordinate.y))
        
        return CGPoint(x: x, y: y)
    }
    
    func calculateProportion(of fieldSize: CGSize, width: CGFloat, height: CGFloat) -> CGSize {
        let bWidth = (fieldSize.width - offsets.width * 2) * width
        let bHeight = (fieldSize.height - offsets.height * 2) * height
        return CGSize(width: bWidth, height: bHeight)
    }
    
    static func nearestGoal(from coordinate: Coordinate) -> Coordinate {
        return coordinate.x <= 9 ? FieldManager.firstGoal : FieldManager.secondGoal
    }
    
    static func distance(from currentPosition: Coordinate, to newPosition: Coordinate) -> Double {
        return sqrt(pow(Double(currentPosition.x - newPosition.x), 2) + pow(Double(currentPosition.y - newPosition.y), 2))
    }
}
