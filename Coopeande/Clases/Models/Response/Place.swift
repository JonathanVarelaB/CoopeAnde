//
//  Place.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Place : EntityBase {
    
    var latitude:NSNumber = 0
    var longitude:NSNumber = 0
    var name:NSString = ""
    var placeId:NSString = ""
    var subCategoryPlaceId:NSString = ""
    var categoryPlaceId:NSString = ""
    
    override func fromJson(_ response: NSDictionary?) {
        if let data = response
        {
            if let value = data["latitude"]
            {
                self.latitude = value as! NSNumber
            }
            
            if let value1 = data["longitude"]
            {
                self.longitude = value1 as! NSNumber
            }
            
            if let value2:AnyObject = data["name"] as AnyObject?
            {
                self.name = value2.description as NSString
            }
            
            if let value3:AnyObject = data["placeId"] as AnyObject?
            {
                self.placeId = value3.description as NSString
            }
            
            if let value3:AnyObject = data["categoryPlaceId"] as AnyObject?
            {
                self.categoryPlaceId = value3.description as NSString
            }
            
            if let value3:AnyObject = data["subCategoryPlaceId"] as AnyObject?
            {
                self.subCategoryPlaceId = value3.description as NSString
            }
            
        }
    }

}
