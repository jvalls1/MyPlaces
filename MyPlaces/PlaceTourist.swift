//
//  PlaceTourist.swift
//  MyPlaces
//
//  Created by user143153 on 29/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation

class PlaceTourist :  Place {
    
    var discount_tourist : String = ""
    
    override init() {
        super.init()
        type = .TouristicPlace
    }
    
    init (name: String, description: String, discount_tourist: String, image_in: Data?) {
        super.init(type:.TouristicPlace,name:name,description:description,image_in:image_in)
        self.discount_tourist=discount_tourist
    }
    
    
    
}
