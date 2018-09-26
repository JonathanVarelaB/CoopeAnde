//
//  GetAllCreditTransactionRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/16/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class GetAllCreditTransactionRequest: BaseRequest {
    
    var operation: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys: [AnyObject] = ["operationId" as AnyObject, "numPage" as AnyObject,"totalByPage" as AnyObject]
        let values: [AnyObject] = [self.operation, 0 as AnyObject, 0 as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
