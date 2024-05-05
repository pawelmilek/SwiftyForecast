//
//  WidgetLocationManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class WidgetLocationManager: NSObject {
    var hasPermission = false
    var isGettingExactLocation = false
    var authorizationStatus: CLAuthorizationStatus
    var accuracyAuthorizationStatus: CLAccuracyAuthorization
    var currentLocation: CLLocation?
    var isObtainingLocation = false

    private let manager: CLLocationManager
    private var completionHandler: ((CLLocation) -> Void)?

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

    func startUpdatingLocation() async -> CLLocation {
        await withCheckedContinuation { continuation in
            self.requestLocation { location in
                continuation.resume(returning: location)
            }
        }
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    private func requestLocation(completionHandler: @escaping (CLLocation) -> Void) {
        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        self.completionHandler = completionHandler
        manager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension WidgetLocationManager: CLLocationManagerDelegate {

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
        guard let latestLocation = locations.first else { return }

        debugPrint("\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)")
        self.completionHandler?(latestLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(
            "\(Date.now.formatted(date: .omitted, time: .standard)) \(#function)", error.localizedDescription
        )
    }
}
