//
//  Coordinate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct Coordinate {
    var latitude: Double
    var longitude: Double
}


// MARK: CustomStringConvertible
extension Coordinate: CustomStringConvertible {
    var description: String {
        let textualDesc = "/\(self.latitude),\(self.longitude)"
        return textualDesc
    }
}
