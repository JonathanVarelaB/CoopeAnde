//
//  PayCreditRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayCreditRequest:BaseRequest {
    
    var operationId: String = ""
    var accountAlias: String = ""
    var receiveTypeId: String = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys: [AnyObject] = ["operationId" as AnyObject as AnyObject,"aliasName" as AnyObject,"creditReceiveTypeId" as AnyObject]
        let values :[AnyObject] = [self.operationId as AnyObject, self.accountAlias as AnyObject, self.receiveTypeId as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
