//
//  Credits.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditTypesByUser: EntityBase {
    
    var count: NSNumber = 0
    var list: Array<CreditType> = []
    var colorIndex: Int = 0
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["creditTypeCount"] as? NSNumber{
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "creditTypeList") as? NSArray{
                list = []
                for item in value4{
                    let detail = CreditType()
                    detail.fromJson( item as? NSDictionary)
                    detail.color = self.colorIndex
                    list.append(detail)
                    self.colorIndex = (self.colorIndex < 3) ? (self.colorIndex + 1) : 0
                }
            }
        }
    }
}

