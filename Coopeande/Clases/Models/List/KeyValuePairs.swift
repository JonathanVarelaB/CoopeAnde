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
    var list:   Array<KeyValuePair> = []
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
                    var detail = KeyValuePair()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
