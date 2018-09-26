//
//  TransferTypes.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferTypes  : EntityBase {
    
    var count: NSNumber = 0
    var list:  Array<TransferType> = []
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value3 = data ["transferTypeTotal"] as? NSNumber
            {
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "transferTypesList") as? NSArray
            {
                list = []
                
                for item in value4                {
                    var detail = TransferType()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
