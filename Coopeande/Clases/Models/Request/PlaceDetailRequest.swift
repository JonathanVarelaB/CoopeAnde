//
//  PlaceDetailRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceDetailRequest  : BaseRequest {
    
    var categoryPlaceId: NSString = ""
    var subCategoryPlaceId: NSString = ""
    var latitude: NSNumber = 0
    var longitude: NSNumber = 0
    var placeId: NSString = ""
    var typeId: NSString = ""
    var currentLatitude: NSString = ""
    var currentLongitude: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let keys :[AnyObject] = ["categoryPlaceId" as AnyObject, "latitude" as AnyObject,"longitude" as AnyObject, "placeId" as AnyObject,"typeId" as AnyObject,"subCategoryPlaceId" as AnyObject, "currentLatitude" as AnyObject, "currentLongitude" as AnyObject]
        let values :[AnyObject] = [self.categoryPlaceId, self.latitude,self.longitude,self.placeId ,self.typeId, self.subCategoryPlaceId, self.currentLatitude, self.currentLongitude]
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
    
}
