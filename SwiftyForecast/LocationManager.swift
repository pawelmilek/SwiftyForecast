//
//  LocationManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

// swiftlint:disable switch_case_alignment
import Foundation
import CoreLocation

@MainActor
final class LocationManager: NSObject {
    @Published var hasPermission = false
    @Published var isGettingExactLocation = false
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var accuracyAuthorizationStatus: CLAccuracyAuthorization
    @Published var currentLocation: CLLocation?
    @Published var error: Error?
    @Published var isObtainingLocation = false

    private let manager: CLLocationManager

    override init() {
        manager = CLLocationManager()
        authorizationStatus = manager.authorizationStatus
        accuracyAuthorizationStatus = manager.accuracyAuthorization

        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.distanceFilter = kCLLocationAccuracyThreeKilometers
        manager.pausesLocationUpdatesAutomatically = true
        manager.showsBackgroundLocationIndicator = true
        manager.activityType = .otherNavigation
    }

    func requestLocation() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        isObtainingLocation = true
        manager.requestLocation()
    }

    func startUpdatingLocation() {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        isObtainingLocation = true
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

        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            hasPermission = false
        case .authorizedAlways, .authorizedWhenInUse:
            hasPermission = true
        @unknown default:
            hasPermission = false
        }

        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            isGettingExactLocation = true
        case .reducedAccuracy:
            isGettingExactLocation = false
        @unknown default:
            isGettingExactLocation = false
        }

        debugPrint(
            "\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)",
            authorizationStatus.description,
            accuracyAuthorizationStatus.description
        )
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)", lastLocation)
        self.isObtainingLocation = false
        self.currentLocation = lastLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let code = (error as NSError).code

        if code == CLError.Code.locationUnknown.rawValue {
            debugPrint("Unable to retrieve a location right away keeps trying...")

        } else if code == CLError.Code.denied.rawValue {
            manager.stopUpdatingLocation()
        }

        self.error = error
        self.isObtainingLocation = false
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)", code)
    }

}

// MARK: - CustomStringConvertible
extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        return switch self {
        case .notDetermined:  "Not Determined"
        case .authorizedWhenInUse: "Authorized When In Use"
        case .authorizedAlways: "Authorized Always"
        case .restricted: "Restricted"
        case .denied: "Denied"
        @unknown default: "Unknown"
        }
    }
}

// MARK: - CustomStringConvertible
extension CLAccuracyAuthorization: CustomStringConvertible {
    public var description: String {
        return switch self {
        case .fullAccuracy: "Full Accuracy"
        case .reducedAccuracy: "Reduced Accuracy"
        @unknown default: "Unknown"
        }
    }
}
