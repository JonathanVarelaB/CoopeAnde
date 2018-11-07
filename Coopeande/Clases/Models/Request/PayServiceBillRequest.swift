//
//  PayServiceBillRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/3/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayServiceBillRequest:BaseRequest {
    
    var aliasTypeId: NSString?
    var aliasServiceName: NSString?
    var aliasNameAccount:NSString?
    var bill: NSString?
    var receipt: NSString?
    var amount: String = ""
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        let keys :[AnyObject] = ["aliasTypeId" as AnyObject, "aliasNameAccount" as AnyObject, "aliasServiceName" as AnyObject, "bill" as AnyObject, "receipt" as AnyObject, "amount" as AnyObject]
        let values :[AnyObject] = [self.aliasTypeId!, self.aliasNameAccount!,self.aliasServiceName! , self.bill!, self.receipt!, self.amount as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
        
    }
}
