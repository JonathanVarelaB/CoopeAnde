//
//  AddFavoriteRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class FavoriteRequest: BaseRequest {
    
    var name: NSString = ""
    var phoneNumber: NSString = ""
    
    override func toJson() ->  NSMutableDictionary? {
        let data = super.toJson()
        let keys: [AnyObject] = ["name" as AnyObject, "phoneNumber" as AnyObject]
        let values: [AnyObject] = [self.name, self.phoneNumber]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
