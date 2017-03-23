//: Playground - noun: a place where people can play

import UIKit

struct Match {
    let date:Date
    let competition:String  // let's keep it simple for now
    let homeTeam:Team
    let awayTeam:Team
    let score:Score
    let timeline:[Play]
}

struct Score {
    let halfTime:(UInt8, UInt8)
    let fullTime:(UInt8, UInt8)
}

struct Team {
    let name:String
    let country:String // let's keep it simple for now
    let players:[Player]
}

struct Player:Equatable, Hashable {
    
    struct Name:Hashable {
        let full:String?
        let short:String
        let jersey:String
        
        var hashValue: Int {
            return full?.hashValue ?? 0 ^ short.hashValue ^ jersey.hashValue
        }

        static func == (lhs:Name, rhs: Name) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }

    let name:Name
    let number:UInt8
    
    var hashValue: Int {
        return name.hashValue ^ number.hashValue
    }
}

extension Player {
    static func == (lhs:Player, rhs:Player) -> Bool {
        return lhs.name.full == rhs.name.full
            && lhs.name.jersey == rhs.name.jersey
            && lhs.number == rhs.number
    }
}

struct Play {
    let scored:Bool
    let offside:Bool = false
    let kind:Kind
    let ball:[String]
    let homeTeam:[Player:[String]]
    let awayTeam:[Player:[String]]
}

typealias Kind = PlayKind

enum PlayKind {
    case OpenPlay
    case Freekick
    case Penalty
    case Corner
    case ThrowIn
}

struct BallTracker {
    let positions:[String]
}

struct PlayerTracker {
    let players:[Player:[String]]
}



