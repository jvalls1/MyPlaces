//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by user143153 on 29/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation

class ManagerPlaces {
    
    // Container of Places.
    var thePlaces:  [Place] =   []
    
    // Functions to manage Places
    func append(_value: Place) {
        thePlaces.append(_value)
    }
    // Return the numbers of Places Objects contained in the array
    func GetCount() -> Int {
        return thePlaces.count
    }

    // Return the Place Object positioned at posintion number specified
    func GetItemAt(position: Int) -> Place {
        return thePlaces [position]
    }
    
    // Remove a Place Object passing the object.
    func remove(_value: Place) {
        if (thePlaces.contains {$0.id == _value.id }) {
            thePlaces.removeAll {$0.id == _value.id }
        }
    }
    
    // Return all Places in Array Format
    func getPlaces() -> [Place] {
        return thePlaces
    }

    
    // Singleton. Unique instance for All Application
    private static var sharedManagerPlaces : ManagerPlaces = {
        
        var singletonManager: ManagerPlaces
        singletonManager = ManagerPlaces()
        return singletonManager
    
    }()
    
    class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
    }
    
}





