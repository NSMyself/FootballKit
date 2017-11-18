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
    
    func color() -> CGColor {
        switch(self) {
        case .run: return UIColor.red.cgColor
        case .pass: return UIColor.blue.cgColor
        }
    }
    
    func dashPattern() -> [NSNumber]? {
        return (self == .run) ? [4,4] : nil
    }
}
