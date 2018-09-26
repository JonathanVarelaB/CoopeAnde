//
//  Services.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Services : EntityBase {
    
    var count: NSNumber = 1
    var list:   Array<Service> = []
    var colorIndex: Int = 0
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response {
            if let value3 = data ["paymentServiceTypeTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "paymentServiceTypeList") as? NSArray{
                list = []
                for item in value4{
                    let detail = Service()
                    detail.fromJson( item as? NSDictionary)
                    detail.color = self.colorIndex
                    list.append(detail)
                    self.colorIndex = (self.colorIndex < 3) ? (self.colorIndex + 1) : 0
                }
            }
        }
    }
}
