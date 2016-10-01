//
//  LocationDatastore.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation


class LocationDatastore: NSObject, CLLocationManagerDelegate {
    fileprivate let locationManager = CLLocationManager()
    typealias LocationClosure = (Coordinate) -> Void
    
    fileprivate let locationFound: LocationClosure
    
    
    init(closure: @escaping LocationClosure){
        self.locationFound = closure
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 200
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    // Tells the delegate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let updatedlocatons = locations as NSArray
        let locationObject = updatedlocatons.lastObject as! CLLocation
        let coordinate = locationObject.coordinate
        
        
        // Update in the main thread
        DispatchQueue.main.async {
            let coordinate = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.locationFound(coordinate)
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var locationStatus = "Not Started"
        var isAccess = false
        
        switch status {
        case .restricted:
            locationStatus = "Restricted Access to location."
            
        case .denied:
            locationStatus = "User denied access to location."
            
        case .notDetermined:
            locationStatus = "Status not determined."
            
        default:
            locationStatus = "Allowed to location Access."
            isAccess = true
        }
        
        if isAccess {
            self.locationManager.startUpdatingLocation()
            
        } else {
            print("Denied access: \(locationStatus)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        AlertController.presentErrorAlert(error: error)
        
        // Update in the main thread
        DispatchQueue.main.async {
            // Set default location Wood Dale, IL, USA
            let coordinate = Coordinate(latitude: 41.9633007075677, longitude: -87.9966500494604)
            self.locationFound(coordinate)
        }
    }
}
