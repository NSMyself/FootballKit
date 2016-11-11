//
//  ViewController.swift
//  FootballAnimation
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       let items = parseJSON()
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

