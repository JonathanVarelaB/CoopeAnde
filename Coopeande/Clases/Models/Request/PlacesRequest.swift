//
//  PlacesRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlacesRequest : BaseRequest {

    var categoryPlaceId: NSString = ""
    var latitude: NSNumber = 0
    var longitude: NSNumber = 0
    
    var subCategoryPlaceId: NSString = ""
    override func toJson() ->  NSMutableDictionary?
    {
        let keys :[AnyObject] = ["categoryPlaceId" as AnyObject, "latitude" as AnyObject, "longitude" as AnyObject,"subCategoryPlaceId" as AnyObject]
        let values :[AnyObject] = [self.categoryPlaceId, self.latitude, self.longitude,self.subCategoryPlaceId]
        
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
}
