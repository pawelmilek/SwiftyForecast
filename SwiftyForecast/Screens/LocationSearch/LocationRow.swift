//
//  LocationRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationRow: View {
    let item: LocationModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            headerView
            mapView
                .overlay(
                    RoundedRectangle(cornerRadius: Style.LocationRow.cornerRadius)
                        .stroke(
                            Style.LocationRow.borderColor,
                            lineWidth: Style.LocationRow.lineBorderWidth
                        )
                )
                .compositingGroup()
                .shadow(
                    color: Style.LocationRow.shadowColor,
                    radius: Style.LocationRow.shadowRadius,
                    x: Style.LocationRow.shadowOffset.x,
                    y: Style.LocationRow.shadowOffset.y
                )
        }
        .padding(8)
        .frame(minHeight: 145, maxHeight: 145)
        .fixedSize(horizontal: false, vertical: true)
        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .onAppear {
            position = .region(region)
        }
    }
}

private extension LocationRow {

    var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(localTime)
                .font(Style.LocationRow.timeFont)
                .foregroundStyle(Style.LocationRow.timeColor)
            Text(name)
                .font(Style.LocationRow.nameFont)
                .foregroundStyle(Style.LocationRow.nameColor)
        }
    }

    var mapView: some View {
        Map(position: $position, interactionModes: []) {
            Marker(name, coordinate: region.center)
                .tint(Style.LocationRow.timeColor)
        }
        .cornerRadius(Style.LocationRow.cornerRadius)
    }

    var localTime: String {
        Date.timeOnly(from: item.secondsFromGMT)
    }

    var name: String {
        item.name + ", " + item.country
    }

    var region: MKCoordinateRegion {
        let annotation = MKPointAnnotation()
        annotation.subtitle = "\(item.name) \(item.state)"
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: item.latitude,
            longitude: item.longitude
        )

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        return region
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationRow(item: LocationModel.examples.first!)
}
