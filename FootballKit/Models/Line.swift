//
//  Line.swift
//  FootballKit
//
//  Created by João Pereira on 13/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

enum Line: String {
    case run
    case pass
    
    func color() -> UIColor {
        switch(self) {
        case .run: return UIColor.red
        case .pass: return UIColor.blue
        }
    }
    
    func dashPattern() -> [Int]? {
        return (self == .run) ? [4,4] : nil
    }
}

