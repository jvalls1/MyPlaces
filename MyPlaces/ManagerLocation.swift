//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by user143153 on 20/10/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit
import UserNotifications

class ManagerLocation : NSObject,CLLocationManagerDelegate {
    
    var m_locationManager:CLLocationManager!
    var location: CLLocationCoordinate2D!
    
    // For educational aim.
    var firsTime : Bool = true
    
    public func getLocation()->CLLocationCoordinate2D!
    {
        return (self.m_locationManager!.location?.coordinate)!
    }
    
    private static var sharedManagerLocation: ManagerLocation = {
        
        var singletonManager:ManagerLocation?
        
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        
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
                singletonManager!.m_locationManager.startUpdatingLocation()
            }
            else {
                singletonManager!.m_locationManager.startUpdatingLocation()
                singletonManager!.location = singletonManager!.m_locationManager!.location?.coordinate
            }
            
            center.requestAuthorization(options: [.alert,.sound,.badge]) {
                (granted,error) in
                // Enabled or disabled features based on authorization.
                
            }
            
        }
        return singletonManager!
    }()
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
        
        let m_location = locations [locations.endIndex-1]
        print("Print a la Consola")
        
        if(firsTime){
            
            let content = UNMutableNotificationContent()
            content.title = "Meeting Reminder"
            content.subtitle = "Message subtitle"
            content.body = "Don't forget to bring coffee."
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            // Handle error
                
            })
           
            
            firsTime = false;
        }
        
    }
    
    class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
}
