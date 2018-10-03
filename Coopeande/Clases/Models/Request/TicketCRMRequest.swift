//
//  TicketCRMRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TicketCRMRequest : BaseRequest {
    
    var customerId: NSString = ""
    var latitude: NSNumber = 0
    var longitude: NSNumber = 0
    var placeId: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let keys :[AnyObject] = ["IdCustomer" as AnyObject, "latitude" as AnyObject, "longitude" as AnyObject, "placeId" as AnyObject]
        let values :[AnyObject] = [self.customerId, self.latitude, self.longitude, self.placeId]
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
    
}
