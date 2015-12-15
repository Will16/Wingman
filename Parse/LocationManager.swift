//
//  LocationManager.swift
//  ImageUploader
//
//  Created by Root on 03/08/14.
//
//

import Foundation
import UIKit
import CoreLocation

protocol userLocationProtocol {
    func didReceiveUserLocation(location: CLLocation)
}



let GlobalVariableSharedInstance = LocationManager()


class LocationManager: NSObject,  CLLocationManagerDelegate
{
    

    var delegate: userLocationProtocol?
    var coreLocationManager = CLLocationManager()

    

    /*
    if CLLocationManager.locationServicesEnabled() {
          coreLocationManager.startUpdatingLocation()
    }
*/

    
    class var SharedLocationManager: LocationManager
    {
        GlobalVariableSharedInstance.coreLocationManager.requestAlwaysAuthorization()
        
      
        return GlobalVariableSharedInstance
        
    }
    
    func startUpdatingLocation() {
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            coreLocationManager.requestAlwaysAuthorization()
        }
        
        coreLocationManager.startUpdatingLocation()
        print("start updating location", terminator: "")
    }
    
    
//    func initLocationManager()
//    {
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            coreLocationManager.delegate = self
//            coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
//            coreLocationManager.startUpdatingLocation()
//            coreLocationManager.startMonitoringSignificantLocationChanges()
////            coreLocationManager.st
//        }
//        else
//        {
//            let alert:UIAlertView = UIAlertView(title: "Error", message: "Location Services not Enabled. Please enable Location Services in your phone settings.", delegate: nil, cancelButtonTitle: "Ok")
//            alert.show()
//        }
//    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("LOCATION UPDATED...")
        
        let location = getLatestMeasurementFromLocations(locations)
        
        
        print("my location: \(location)", terminator: "")
        if isLocationMeasurementNotCached(location)  && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
           
            
            if (locations.count > 0)
            {
     
                // the last location is the good one?
                let newLocation:CLLocation = locations[0]
                
//                   let newLocation = CLLocation(latitude: 33.74900, longitude: -84.38798)
//
                delegate?.didReceiveUserLocation(newLocation)
     
                
      
                
            } else {
                
                let newLocation = CLLocation(latitude: 33.74900, longitude: -84.38798)
                
                delegate?.didReceiveUserLocation(newLocation)
                
            }
        }
       
        else {
            let newLocation = CLLocation(latitude: 33.74900, longitude: -84.38798)
            
            delegate?.didReceiveUserLocation(newLocation)
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.AuthorizedAlways)
        {
            print("Location manager is authorized...")
        }
        else if(status == CLAuthorizationStatus.Denied)
        {
            coreLocationManager.stopUpdatingLocation()
            coreLocationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    

    func stopUpdatingLocation() {
        lManager.stopUpdatingLocation()
        lManager.delegate = nil
    }
    
    func currentLocation() -> CLLocation {
        var location:CLLocation? = coreLocationManager.location
        
        
        if (location==nil) {
            print("Location is nil!")
            location = CLLocation(latitude: 51.368123, longitude: -0.021973)
        }


        return location!
    }
    
    //if error stop updating location
    func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1] as! CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        return location.timestamp.timeIntervalSinceNow <= 10.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        return location.horizontalAccuracy >= 0
    }
    
    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
        
        return location.horizontalAccuracy <= coreLocationManager.desiredAccuracy
    }
    

    
   
}

