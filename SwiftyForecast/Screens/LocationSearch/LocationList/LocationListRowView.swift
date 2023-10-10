//
//  LocationListRowView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationListRowView: View {
    let currentTime: String
    let location: String
    let coordinate: CLLocationCoordinate2D
    let region: MKCoordinateRegion
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 0) {
                Text(currentTime)
                    .font(.subheadline)
                    .foregroundStyle(Color(Style.LocationListRow.timeColor))
                Text(location)
                    .font(.headline)
                    .foregroundStyle(Color(Style.LocationListRow.locationNameColor))
            }
            .fontWeight(.bold)
            .fontDesign(.rounded)

            Map(position: $position)/*(interactionModes: [])*/ {
                Marker(location, coordinate: coordinate)
                    .tint(Color(Style.LocationListRow.timeColor))
            }
            .frame(maxHeight: 140)
            .cornerRadius(Style.Annotation.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Style.LocationListRow.cornerRadius)
                    .stroke(Color(Style.LocationListRow.timeColor), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
        .onAppear {
            position = .region(region)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationListRowView(
        currentTime: "17:09 PM",
        location: "Rzeszow, Poland",
        coordinate: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994),
        region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.048, longitude: 21.9994), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    )
}
