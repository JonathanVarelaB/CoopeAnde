//
//  PlaceMarker.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import MapKit

class PlaceMarker: MKPointAnnotation {
    // 1
    let place: Place
    
    // 2
    init(place: Place) {
        self.place = place
        super.init()
        
        self.coordinate=CLLocationCoordinate2DMake(CLLocationDegrees(truncating: place.latitude), CLLocationDegrees(truncating: place.longitude))
        self.title = place.name as String
    }
}
