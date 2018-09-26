//
//  CreditCalculatorRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditCalculatorRequest: BaseRequest {
    
    var currencyTypeId: String = ""
    var amount: NSNumber = 0
    var term: NSNumber = 0
    var interest: NSNumber = 0
    var creditTypeId: String = ""
    
    override func toJson() -> NSMutableDictionary? {
        let data = super.toJson()
        let keys :[AnyObject] = ["currencyTypeId" as AnyObject, "amount" as AnyObject, "term" as AnyObject, "interest" as AnyObject, "creditTypeId" as AnyObject]
        let values :[AnyObject] = [self.currencyTypeId as AnyObject, self.amount, self.term, self.interest, self.creditTypeId as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
}
