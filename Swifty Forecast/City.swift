//
//  City.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


/*
 * NSKeyedArchiver serializes objects by taking advantage of methods by conforming to the NSCoding protocol.
 * It can't automatically infer how to save custom classes.
 */
final class City: NSObject, NSCoding {
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double
    //var coordinate: Coordinate
    
    
    init(name: String, country: String, latitude: Double, longitude: Double) {
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.country = aDecoder.decodeObject(forKey: "country") as! String
        self.latitude = aDecoder.decodeDouble(forKey: "lat")
        self.longitude = aDecoder.decodeDouble(forKey: "long")
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.latitude, forKey: "lat")
        aCoder.encode(self.longitude, forKey: "long")
    }
}


extension City {
    var fullName: String {
        return "\(self.name), \(self.country)"
    }
}
