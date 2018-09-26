//
//  ReceiptDetailServiceRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ReceiptDetailServiceRequest: BaseRequest {
    
    var aliasTypeId: NSString?
    var aliasServiceName: NSString?
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys :[AnyObject] = ["aliasTypeId" as AnyObject, "aliasServiceName" as AnyObject]
        let values :[AnyObject] = [self.aliasTypeId!, self.aliasServiceName!]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
}
