//
//  Place.swift
//  MyPlaces
//
//  Created by user143153 on 29/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit


class Place : Codable {
    
    enum PlacesTypes : Int, Codable {
        case GenericPlace
        case TouristicPlace
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case description
        case name
        case type
        case latitude
        case longitude
    }
    
    var id : String = ""
    var type : PlacesTypes = .GenericPlace
    var name : String = ""
    var description : String = ""
    var location : CLLocationCoordinate2D!
    var image_in : Data? = nil
    
    init() {
        self.id=UUID().uuidString
    }
    
    // Giving an unique identifier to the Object. Low probability to collision.
    init(name: String, description: String, image_in: Data?) {
        
        self.id=UUID().uuidString
        self.description=description
        self.name = name
        self.image_in = image_in
        
    }
    
    init(type: PlacesTypes, name: String, description: String, image_in :Data?) {
        
        self.id = UUID().uuidString
        self.name=name
        self.description=description
        self.image_in=image_in
        self.type = type
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Para cada propiedad
        try container.encode(id,forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude,forKey: .longitude)
        
    }
    
    func decode(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(PlacesTypes.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // S'afegeix Image_In.
        let imageFileURL = NSURL(fileURLWithPath: FileSystem.GetPathImage(id: id))
        image_in = try Data(contentsOf: imageFileURL as URL)
    
    }
    
    required convenience init(from decoder: Decoder) throws {
    
        self.init()
        try decode(from: decoder)
    
    }

}


