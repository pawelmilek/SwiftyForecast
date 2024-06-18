//
//  LocationManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var accuracyAuthorizationStatus: CLAccuracyAuthorization
    @Published var location: CLLocation?
    @Published var error: Error?
    @Published var isRequestingLocation = false

    private let manager: CLLocationManager

    override init() {
        manager = CLLocationManager()
        authorizationStatus = manager.authorizationStatus
        accuracyAuthorizationStatus = manager.accuracyAuthorization

        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
//        manager.pausesLocationUpdatesAutomatically = true
        manager.showsBackgroundLocationIndicator = true
        manager.activityType = .otherNavigation
    }

    func requestLocation() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        isRequestingLocation = true
        manager.requestLocation()
    }

    func startUpdatingLocation() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        isRequestingLocation = true
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        manager.stopUpdatingLocation()
    }

    func requestAuthorization() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        manager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        accuracyAuthorizationStatus = manager.accuracyAuthorization

        debugPrint(
            "\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)",
            authorizationStatus.description,
            accuracyAuthorizationStatus.description
        )
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let lastLocation = locations.last else { return }
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)", lastLocation)
        self.isRequestingLocation = false
        self.location = lastLocation
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        let code = (error as NSError).code

        if code == CLError.Code.locationUnknown.rawValue {
            debugPrint("Unable to retrieve a location right away keeps trying...")

        } else if code == CLError.Code.denied.rawValue {
            manager.stopUpdatingLocation()
        }

        self.error = error
        self.isRequestingLocation = false
    }
}
