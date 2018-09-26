//
//  PaidBill.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/3/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PaidBill: EntityBase {
    
    var transactionId: NSString = ""
    var count: NSNumber = 0
    var detailList: Array<KeyValuePair> = []
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["transactionId"] as? NSString{
                self.transactionId = value
            }
            if let value3 = data ["keyValuesTotal"] as? NSNumber{
                self.count = value3
            }
            if let value6: NSArray = data.object(forKey: "keyValuesList") as? NSArray{
                detailList = []
                for item in value6 {
                    let detail = KeyValuePair()
                    detail.fromJson( item  as? NSDictionary)
                    /*
                    let key = detail.key.lowercased as String
                    var value = detail.value as String
                    if key.range(of:"monto") != nil {
                        if value.range(of: "COL") != nil{
                            value = "¢" + value.replacingOccurrences(of: " COL", with: "")
                        }
                        else{
                            if value.range(of: "USD") != nil{
                                value = "$" + value.replacingOccurrences(of: " USD", with: "")
                            }
                        }
                        self.total = value
                        detail.value = value as NSString
                    }*/
                    detailList.append(detail)
                }
            }
        }
    }
    
}
