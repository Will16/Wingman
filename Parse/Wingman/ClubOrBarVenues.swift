//
//  ClubOrBarVenues.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/10/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation
import CoreLocation

class ClubOrBarVenues: NSObject {
    
    let name:String!
    let location:CLLocation!
    let distanceFromUser:CLLocationDistance!
    
    
    init(name: String, location: CLLocation, distanceFromUser: Double) {
        self.name = name
        self.location = location
        self.distanceFromUser = distanceFromUser
    }
}