//
//  TransferRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferRequest: BaseRequest {
    
    var aliasNameDestination: NSString = ""
    var aliasNameOrigin: NSString = ""
    var nameAccountOrigin: NSString = ""
    var nameAccountDestination :NSString = ""
    var reason: NSString = ""
    var total: NSDecimalNumber?
    var typeTransfer: NSString = ""
    
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        let keys :[AnyObject] = ["aliasNameDestination" as AnyObject, "aliasNameOrigin" as AnyObject,"reason" as AnyObject, "total" as AnyObject,"typeTransfer" as AnyObject,"nameAccountOrigin" as AnyObject,"nameAccountDestination" as AnyObject]
        let values :[AnyObject] = [self.aliasNameDestination, self.aliasNameOrigin, self.reason, self.total!,
                                   self.typeTransfer,nameAccountOrigin,nameAccountDestination]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
        
    }
    
}
