//
//  WalletAfilliateNumberRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletAfilliateNumberRequest : BaseRequest {
    
    var aliasName: NSString = ""
    var phoneNumber: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys :[AnyObject] = ["aliasName" as AnyObject, "phoneNumber" as AnyObject]
        let values :[AnyObject] = [self.aliasName, self.phoneNumber]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}

