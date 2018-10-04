//
//  Place.swift
//  MyPlaces
//
//  Created by user143153 on 29/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit


class Place {
    
    enum PlacesTypes {
        case GenericPlace
        case TouristicPlace
    }
    
    var id : String = ""
    var type : PlacesTypes = .GenericPlace
    var name : String = ""
    var description : String = ""
    var location : CLLocationCoordinate2D!
    var image : Data? = nil
    
    init() {
        self.id=UUID().uuidString
    }
    
    // Giving an unique identifier to the Object. Low probability to collision.
    init(name: String, description: String, image_in: Data?) {
        self.id=UUID().uuidString
    }
    
    init(type: PlacesTypes, name: String, description: String, image_in :Data?) {
        self.id = UUID().uuidString
    }

    
}


