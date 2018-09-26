//
//  CreditsByType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditsByType: EntityBase {
    
    var count: NSNumber = 0
    var list: Array<CreditByType> = []

    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["creditCount"] as? NSNumber{
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "creditList") as? NSArray{
                list = []
                for item in value4{
                    let detail = CreditByType()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}

