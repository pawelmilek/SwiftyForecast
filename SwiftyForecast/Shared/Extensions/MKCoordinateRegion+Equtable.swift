//
//  MKCoordinateRegion+Equtable.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 3/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        (lhs.center.latitude == rhs.center.latitude && lhs.center.longitude == rhs.center.longitude) &&
        (lhs.span.latitudeDelta == rhs.span.latitudeDelta && lhs.span.longitudeDelta == rhs.span.longitudeDelta)
    }
}
