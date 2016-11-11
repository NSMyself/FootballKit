//
//  ViewController.swift
//  FootballAnimation
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var background: UIImageView?
	

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
	}
	override func viewDidLayoutSubviews() {
		drawPlay("");
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func drawPlay(_ play:Any?) -> Void {
		let items = parseJSON()
		let play = items[0]
		
		var lastPlace:String? = nil
		
		for player in play.players {
			var alpha = player.position.count == 1 ? 1.0 : 0.5
			
			if let p = player.position.first {
				if let lp = lastPlace {
					drawPass(lp,p)
				}
			}
			
			var lastRun:String? = nil
			
			for c in player.position {
				if let lr = lastRun {
					drawRun(lr,c)
				}
				drawPlayer(c, number: String(player.number), alpha:alpha);
				alpha = alpha + 0.5
				lastRun = c
			}
			
			if let p = player.position.last  {
				lastPlace = p
			}
			
		}
	}
	func calculatePoint(_ coordinate:String) -> CGPoint {
		let viewSize = background!.bounds;
		let squareSize = CGSize(width: viewSize.width / (18.0 + 1.0), height: viewSize.height / (11.0 + 0.8))
		
		let squareOffset = CGPoint(x: squareSize.width / 2.0, y: squareSize.height / 2.0)
		let xString:String = String(coordinate[coordinate.characters.startIndex])
		
		//let yString = String(coordinate.characters.suffix(coordinate.characters.count - 1))
		let yString = String(coordinate.characters.dropFirst())
		
		//let xPosition:Double = coordinate[coordinate.startIndex]
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWYZ"
		let i = alphabet.index(xString.startIndex, offsetBy: 0)
		let xi = alphabet.distance(from: i, to: (alphabet.range(of: xString)?.lowerBound)!)
		
		let xPosition:Double = Double(xi + 1)
		let yPosition:Double = Double(yString)!
		
		let x:Double = (Double(squareSize.width) * (xPosition - 1.0)) + Double(squareOffset.x) * 1.3
		let y:Double = (Double(squareSize.height) * (yPosition - 1.0)) + Double(squareOffset.y) * 1.4
		
		return CGPoint(x: x, y: y)
	}
	func drawPlayer(_ coordinate:String, number:String) -> Void {
		return drawPlayer(coordinate, number: number, alpha: 1.0)
	}
	func drawPlayer(_ coordinate:String, number:String, alpha:Double) -> Void {
		let viewSize = background!.bounds;
		let size = viewSize.height / 12.0 * 0.6
		// calculate position
		let point = calculatePoint(coordinate);
		
		let rect = CGRect(x: point.x, y: point.y, width:size, height: size);
		// draw red circle
		let player = UILabel(frame: rect)
		player.backgroundColor = UIColor.red;
		player.textColor = UIColor.white;
		player.textAlignment = .center;
		player.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightBold);
		player.layer.borderWidth = 1.0;
		player.layer.masksToBounds = true;
		player.layer.borderColor = UIColor.red.cgColor;
		player.layer.cornerRadius = rect.size.height / 2.0
		player.text = number;
		player.alpha = CGFloat(alpha);
		
		if let bg = self.background {
			bg.addSubview(player)
		}
		
	}
	func drawRun(_ coordinateStart:String, _ coordinateEnd:String) -> Void {
		return drawLine(coordinateStart, coordinateEnd, "run")
	}
	
	func drawPass(_ coordinateStart:String, _ coordinateEnd:String) -> Void {
		return drawLine(coordinateStart, coordinateEnd, "pass")
	}
	
	func drawLine(_ coordinateStart:String, _ coordinateEnd:String, _ type:String) -> Void {
		let viewSize = background!.bounds;
		let size = viewSize.height / 12.0 * 0.6
		
		var point1 = calculatePoint(coordinateStart);
		var point2 = calculatePoint(coordinateEnd);
		
		point1.x = point1.x + size / 2.0;
		point1.y = point1.y + size / 2.0;
		point2.x = point2.x + size / 2.0;
		point2.y = point2.y + size / 2.0;
		
		// Draw line
		let path = UIBezierPath()
		path.move(to: point1)
		path.addLine(to: point2)
		
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		layer.strokeColor = (type == "run" ? UIColor.red.cgColor : UIColor.blue.cgColor)
		layer.lineDashPattern = (type == "run" ? [4, 4] : nil)

		layer.lineWidth = 3.0
		
		if let bg = self.background {
			bg.layer.addSublayer(layer)
		}
	}

    // MARK: - ParseJSON
    func parseJSON() -> [Position] {
        do {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "goals", ofType: "json")!)
            let data = try Data(contentsOf: url)
            
            let goalsJSON = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = goalsJSON as? [String:Any] {
                
                if let list = dictionary["list"] as? [[String:Any]] {
                    
                    return list.map { (goal) -> Position? in
                        
                        let positions = goal["playerPositions"] as? [[String:Any]]
                        
                        return positions.map { (playerPosition) -> Position in
                            
                            let players = playerPosition.map { (player) -> Player? in
                                
                                guard let movements = player["positions"] as? [String] else { return nil }
                                
                                let name = player["name"] as? String ?? "Someone"
                                let number = player["number"] as? Int ?? 0
                                
                                return Player(name: name, number: number, position: movements)
                                }.flatMap { $0 }
                            
                            return Position(players: players)
                        }
                    }.flatMap { $0 }
                }
            }
        }
        catch _ {
            print("Could not load shots!")
        }
        
        return []
    }
}

extension UIBezierPath {
	
	class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
		let length = hypot(end.x - start.x, end.y - start.y)
		let tailLength = length - headLength
		
		func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
		let points: [CGPoint] = [
			p(0, tailWidth / 2),
			p(tailLength, tailWidth / 2),
			p(tailLength, headWidth / 2),
			p(length, 0),
			p(tailLength, -headWidth / 2),
			p(tailLength, -tailWidth / 2),
			p(0, -tailWidth / 2)
		]
		
		let cosine = (end.x - start.x) / length
		let sine = (end.y - start.y) / length
		let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
		
		let path = CGMutablePath.init()
		path.addLines(between: points, transform: transform)
		path.closeSubpath()
		
		return self.init(cgPath: path)
	}
	
}
