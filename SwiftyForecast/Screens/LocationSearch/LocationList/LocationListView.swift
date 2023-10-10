//
//  LocationListView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationListView: View {
    @ObservedObject var viewModel: LocationListView.ViewModel

    var body: some View {
        List {
            LocationListRowView(
                currentTime: "17:09 PM",
                location: "Rzeszow, Poland",
                coordinate: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
            LocationListRowView(
                currentTime: "17:09 PM",
                location: "Rzeszow, Poland",
                coordinate: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
            LocationListRowView(
                currentTime: "17:09 PM",
                location: "Rzeszow, Poland",
                coordinate: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        }
//        .edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    LocationListView(viewModel: LocationListView.ViewModel())
}
