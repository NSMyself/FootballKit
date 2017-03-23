//
//  JSONParser.swift
//  FootballKit
//
//  Created by João Pereira on 12/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

struct JSONParser {
    
    static func parse(url:URL) -> [Play] {
        
        do {
            /*
            let data = try Data(contentsOf: url)
            
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
                
                if let list = dictionary["list"] as? [JSONDictionary] {
                    
                    return list.map { (goal) -> Play? in
                        
                        let positions = goal["playerPositions"] as? [JSONDictionary]
                        
                        return positions.map { (playerPosition) -> Play in
                            
                            let players = playerPosition.map { (player) -> Player? in
                                
                                guard let movements = player["positions"] as? [String] else { return nil }
                                
                                let name = player["name"] as? String ?? "Someone"
                                let number = player["number"] as? Int ?? 0
                                
                                return Player(name: name, number: number, position: movements)
                                }.flatMap { $0 }
                            
                            return Play(players: players)
                        }
                    }.flatMap { $0 }
                }
            }*/
        }
        catch _ {
            print("Could not load shots!")
        }
        
        return []
    }
}
