//
//  CreditTypes.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditTypes : EntityBase {
    
    var count: NSNumber?
    var list: Array<CreditType> = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        return CreditTypes(count: count!, list: list)
    }
    
    init(count: NSNumber, list: Array<CreditType>){
        self.count = count
        self.list = list
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["calculatorTypeTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "calculatorTypeList") as? NSArray{
                list = []
                for item in value4{
                    let detail = CreditType()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
