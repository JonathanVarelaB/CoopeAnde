//
//  CreditTransactions.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/16/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditTransactions: EntityBase {
    
    var count: NSNumber?
    var totalByPage: NSNumber?
    var list: Array<CreditTransaction> = []
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["creditTransTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "creditList") as? NSArray{
                list = []
                for item in value4{
                    var detail = CreditTransaction()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
