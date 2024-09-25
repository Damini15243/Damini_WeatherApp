//
//  LocationManager.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateAuthorization(status: CLAuthorizationStatus)
    func didFailWithError(error: Error)
    func didUpdateLocation(location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    weak var delegate: LocationManagerDelegate?

    override init() {
        self.locationManager = CLLocationManager()
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // Start requesting location permission
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.didUpdateAuthorization(status: status)
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.didUpdateAuthorization(status: status)
            locationManager.startUpdatingLocation()
        @unknown default:
            delegate?.didUpdateAuthorization(status: status)
        }
    }

    // Delegate method for authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didUpdateAuthorization(status: status)

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    // Delegate method for receiving location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didUpdateLocation(location: location)
        }
        // Stop updating location to save battery life
        locationManager.stopUpdatingLocation()
    }

    // Delegate method for errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
