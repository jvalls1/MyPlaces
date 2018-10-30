//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by user143153 on 29/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation


protocol ManagerPlacesObserver {
    	func onPlacesChange()
}

class ManagerPlaces : Codable {
    
    // Constants Dedicates to Coding and Decoding Services
    enum CodingKeys: String, CodingKey {
        case places
    }
    enum PlacesTypeKey: CodingKey {
        case type
    }
    
    // Listado de observadores.
    public var m_observers = Array<ManagerPlacesObserver>()
    
    // Add a list of a m_observers
    public func addObserver(object: ManagerPlacesObserver) {
        m_observers.append(object)
    }
    
    // Execute the protocol on Places Change
    public func updateObservers() {
        for observers in m_observers {
            observers.onPlacesChange()
        }
    }
    
    // Method to add path Image
    func getPathImage(p: Place) -> String {
        let pathImage = FileSystem.GetPathImage(id: p.id)
        return pathImage
    }

    // Container of Places.
    var places:  [Place] =  []
    
    // Functions to manage Places
    func append(_value: Place) {
        places.append(_value)
    }

    // Return the numbers of Places Objects contained in the array
    func getCount() -> Int {
        return places.count
    }

    // Return the Place Object positioned at posintion number specified
    func getItemAt(position: Int) -> Place {
        return places [position]
    }
    
    func getItemById(_id : String) -> Place {
        return places.first { $0.id == _id }!
    }
    
    // deleter a Place Object passing the object, return no value
    func delete(_value: Place) {
        if (places.contains {$0.id == _value.id }) {
            places.removeAll {$0.id == _value.id }
        }
    }
    
    // Remove a Place Object passing the object and returning the Object
    func remove(_value: Place) -> Place!  {
        var removed : Place!
        if (places.contains {$0.id == _value.id }) {
            let orPlaces : [Place]  = self.places.filter {$0.id == _value.id}
            removed = orPlaces.first
            places.removeAll { $0.id == removed.id }
        }
        return removed
    }
    
    // Return all Places in Array Format
    func getPlaces() -> [Place] {
        return places
    }
    
    // ***********************************************************************************************
    // Enconding and decoding functions
    // ***********************************************************************************************
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(places, forKey: .places)
    }
    
    func decode(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = [Place]()
        
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.places)
        var tmp_array = objectsArrayForType
        
        while(!objectsArrayForType.isAtEnd)
        {
            let object = try objectsArrayForType.nestedContainer(keyedBy: PlacesTypeKey.self)
            let type = try object.decode(Place.PlacesTypes.self,forKey: PlacesTypeKey.type)
            
            switch type {
            case Place.PlacesTypes.TouristicPlace:
                self.append(_value: try tmp_array.decode(PlaceTourist.self))
            default :
                self.append(_value: try tmp_array.decode(Place.self))
            }
        }
    }
    
    // *********************************************************************************************
    // Storing and loading functions
    // *********************************************************************************************
    
    func store()
    {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            for place in places {
                if(place.image_in != nil){
                    FileSystem.WriteData(id:place.id,image:place.image_in!)
                    place.image_in = nil
                }
            }
            FileSystem.Write(data: String(data: data, encoding: .utf8)!)
        }
        catch
        {
        }
    }
    
    // Loading function
    private static func load() -> ManagerPlaces? {
        
        var result : ManagerPlaces? = nil
        
        let data_str = FileSystem.Read()
        if (data_str != "") {
            do {
                let decoder = JSONDecoder()
                let data : Data = Data(data_str.utf8)
                result = try decoder.decode(ManagerPlaces.self,from: data)
            }
            catch {
                result = nil
            }
        }
        return result
    }
    
    // Singleton. Unique instance for All Application
    private static var sharedManagerPlaces : ManagerPlaces = {
        
        var singletonManager: ManagerPlaces?
        var tmpManagerPlaces = load()
        
        // If added to workaround the question of Documents.txt
        if tmpManagerPlaces != nil {
            singletonManager = load()
        } else {
            singletonManager = ManagerPlaces()
        }
        return singletonManager!
    
    }()
    
    class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
    }
    
}





