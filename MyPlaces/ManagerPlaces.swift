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
    
    func GetCount() -> Int {
        return thePlaces.count
    }

    func GetItemAt(position: Int) -> Place {
        return thePlaces [position]
    }
    
    func GetItemById(id : String) -> Place {
        return thePlaces [1]
    }
    
    func remove(_value: Place) {
        
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





