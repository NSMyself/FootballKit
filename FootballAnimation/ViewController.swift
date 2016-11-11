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
        // Do any additional setup after loading the view, typically from a nib.
		if let bg = background {
			bg.contentMode = .scaleAspectFit
		}

    }
	override func viewWillAppear(_ animated: Bool) {
		if let bg = background {
			let viewSize = bg.bounds;
			if let img = bg.image {
				let imageSize = img.size
				
				
			}
		}
	}
	override func viewDidLayoutSubviews() {
		drawPlay("");
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func drawPlay(_ play:Any?) -> Void {
		drawPlayer("G2", number: "11");
		
	}
	func calculatePoint(_ coordinate:String) -> CGPoint {
		let viewSize = background!.bounds;
		let squareSize = CGSize(width: viewSize.width / (18.0 + 1.0), height: viewSize.height / (11.0 + 1.0))
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
		let y:Double = (Double(squareSize.height) * (yPosition - 1.0)) + Double(squareOffset.y) * 1.3
		
		return CGPoint(x: x, y: y)
	}
	func drawPlayer(_ coordinate:String, number:String) -> Void {
		// calculate position
		let point = calculatePoint(coordinate);
		
		let rect = CGRect(x: point.x, y: point.y, width: 16, height: 16);
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
		
		if let bg = self.background {
			bg.addSubview(player)
		}
		
	}

}

