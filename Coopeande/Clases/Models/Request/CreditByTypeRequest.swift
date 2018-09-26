//
//  CreditByTypeRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditByTypeRequest: BaseRequest{
    
    var creditTypeId: String?

    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys :[AnyObject] = ["creditTypeId" as AnyObject]
        let values :[AnyObject] = [self.creditTypeId! as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
