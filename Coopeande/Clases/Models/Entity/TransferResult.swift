//
//  TransferResult.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferResult : EntityBase {
    
    var commission: NSNumber = 0
    var transferId: NSString = ""
    var detail: KeyValuePairs?
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["commission"] as? NSNumber{
                self.commission = value3
            }
            if let value4 : AnyObject = data ["transactionId"] as AnyObject?{
                self.transferId = value4.description as NSString
            }
            detail = KeyValuePairs()
            detail!.fromJson(response)
        }
    }
    
}
