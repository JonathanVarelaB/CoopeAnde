//
//  annotationAgency.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 14/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import MapKit

class annotationAgency: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
