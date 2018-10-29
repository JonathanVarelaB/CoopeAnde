//
//  KeyValuePairs.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class KeyValuePairs : EntityBase {
    
    var count: NSNumber = 0
    var list:  Array<KeyValuePair> = []
    var debitAmount: String = ""
    var exchangeRate: String = ""
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value3 = data ["keyValuesTotal"] as? NSNumber
            {
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "keyValuesList") as? NSArray
            {
                list = []
                
                for item in value4
                {
                    let detail = KeyValuePair()
                    detail.fromJson( item as? NSDictionary)
                    if detail.key.lowercased.range(of: "tipo de cambio") != nil {
                        self.exchangeRate = detail.value.description
                    }
                    if detail.key.lowercased.range(of: "monto a debitar") != nil {
                        self.debitAmount = detail.value.description
                    }
                    list.append(detail)
                }
            }
        }
    }
}
