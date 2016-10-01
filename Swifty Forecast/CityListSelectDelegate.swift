//
//  CityListSelectDelegate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


protocol CityListSelectDelegate: class {
    func cityListDidSelect(city: City)
}
