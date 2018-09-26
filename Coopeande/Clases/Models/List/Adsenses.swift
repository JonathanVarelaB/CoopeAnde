//
//  Adsenses.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
class Adsenses  : EntityBase {
    
    var count: NSNumber = 0
    var list:  Array<Ads> = []
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value3 = data ["totalList"] as? NSNumber
            {
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "newsList") as? NSArray
            {
                list = []
                
                for item in value4                {
                    let detail = Ads()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
