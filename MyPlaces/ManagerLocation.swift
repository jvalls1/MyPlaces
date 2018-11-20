//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by user143153 on 20/10/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit

class ManagerLocation : NSObject,CLLocationManagerDelegate {
    
    var m_locationManager:CLLocationManager!
    var location: CLLocationCoordinate2D!
    
    public func getLocation()->CLLocationCoordinate2D!
    {
        return location
    }
    
    private static var sharedManagerLocation: ManagerLocation = {
        
        var singletonManager:ManagerLocation?
        
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if(singletonManager == nil) {
            
            singletonManager = ManagerLocation()
            singletonManager!.m_locationManager = CLLocationManager()
            singletonManager!.m_locationManager.delegate = singletonManager
            
            // Permitir updates en background
            singletonManager!.m_locationManager.allowsBackgroundLocationUpdates = true
            // Minima distancia para que detecte cambio de posición = 500 metros
            singletonManager!.m_locationManager.distanceFilter = 500
            // Que use la forma más optima para calcular la geolocalización.
            singletonManager!.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if (status == CLAuthorizationStatus.notDetermined) {
                singletonManager!.m_locationManager.requestWhenInUseAuthorization()
            }
            else {
                singletonManager!.m_locationManager.startUpdatingLocation()
                singletonManager!.location = singletonManager!.m_locationManager!.location?.coordinate
            }
        }
        return singletonManager!
    }()
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
         location = locations.last!.coordinate
    }
    
    class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
}
