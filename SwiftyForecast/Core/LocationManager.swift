//
//  LocationManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

@MainActor
final class LocationManager: NSObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocation?
    @Published var error: Error?

    var isLocationServiceAuthorized: Bool {
        let authorizationStatus = manager.authorizationStatus

        let isAuthorizedWhenInUse = (authorizationStatus == .authorizedWhenInUse)
        let isAuthorizedAlways = (authorizationStatus == .authorizedAlways)
        return (isAuthorizedWhenInUse || isAuthorizedAlways)
    }

    private let manager: CLLocationManager

    override init() {
        manager = CLLocationManager()
        authorizationStatus = manager.authorizationStatus

        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.activityType = .other
    }

    func requestLocation() {
        debugPrint(#function)
        manager.requestLocation()
    }

    func startUpdatingLocation() {
        debugPrint(#function)
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        debugPrint(#function)
        manager.stopUpdatingLocation()
    }

    func requestAuthorization() {
        debugPrint(#function)
        manager.requestWhenInUseAuthorization()
    }

}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        debugPrint(#function, manager.authorizationStatus.description)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        self.currentLocation = lastLocation
        debugPrint(#function, currentLocation!)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let code = (error as NSError).code

        if code == CLError.Code.locationUnknown.rawValue {
            debugPrint("Unable to retrieve a location right away keeps trying...")

        } else if code == CLError.Code.denied.rawValue {
            manager.stopUpdatingLocation()
        }

        self.error = error
        debugPrint(#function, code)
    }

}

// MARK: - CustomStringConvertible
extension CLAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined:
            return "notDetermined"

        case .authorizedWhenInUse:
            return "authorizedWhenInUse"

        case .authorizedAlways:
            return "authorizedAlways"

        case .restricted:
            return "restricted"

        case .denied:
            return "denied"

        default:
            return "unknown"
        }
    }

}
