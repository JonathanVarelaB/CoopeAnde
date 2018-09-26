//
//  ReceiptServices.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ReceiptService : EntityBase {
    
    var transactionId: NSString = ""
    var bill: NSString = ""
    var receipt: NSString = ""
    var detailCount: NSNumber = 0
    var detailList: Array<KeyValuePair> = []
    var total: String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["transactionId"] as? NSString{
                self.transactionId = value
            }
            if let value3 = data ["bill"] as? NSString{
                self.bill = value3
            }
            if let value4 = data ["receipt"] as? NSString{
                self.receipt = value4
            }
            if let value5 = data ["keyValuesTotal"] as? NSNumber{
                self.detailCount = value5
            }
            if let value6: NSArray = data.object(forKey: "keyValuesList") as? NSArray{
                detailList = []
                for item in value6 {
                    let detail = KeyValuePair()
                    detail.fromJson( item  as? NSDictionary)
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
                    }
                    detailList.append(detail)
                }
            }
            
        }
    }
    
}
