//
//  MoonPhase.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit


struct MoonPhase {
    fileprivate var lunation: Double
    var icon: NSAttributedString? {
        guard let icon = IconType(rawValue: self.description) else { return nil }
        return icon.fontIcon
    }
    
    
    init(lunation: Double) {
        self.lunation = lunation
    }
}


// MARK: CustomStringConvertible
extension MoonPhase: CustomStringConvertible {
    
    var description: String {
        switch self.lunation {
        case 0:
            return "New moon"
            
        case 0.01..<0.25:
            return "Waxing crescent"
            
        case 0.25:
            return "First quarter moon"
            
        case 0.26..<0.5:
            return "Waxing gibbous"
            
        case 0.5:
            return "Full moon"
            
        case 0.51..<0.75:
            return "Waning gibbous"
            
        case 0.75:
            return "Last quarter moon"
            
        case 0.76...1.0:
            return "Waning crescent"
            
        default:
            return "NA"
        }
    }
}
