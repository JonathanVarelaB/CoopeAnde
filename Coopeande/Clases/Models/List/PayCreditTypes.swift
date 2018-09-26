//
//  PayCreditTypes.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayCreditTypes: EntityBase, NSCopying {
    
    var count: NSNumber?
    var list: Array<PayCreditType> = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        return PayCreditTypes(count: count!, list: list)
    }
    
    init(count: NSNumber, list: Array<PayCreditType>){
        self.count = count
        self.list = list
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["creditReceiveTypeTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "creditReceiveTypeList") as? NSArray{
                list = []
                for item in value4{
                    let detail = PayCreditType()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
    
}

