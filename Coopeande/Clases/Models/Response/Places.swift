//
//  Places.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Places : EntityBase {

    var count: NSNumber = 0
    var list:   Array<AnyObject> = []
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value3 = data ["placesTotal"]
            {
                self.count = value3 as! NSNumber
            }
            if let value4: NSArray = data.object(forKey: "placesList") as? NSArray
            {
                list = []
                
                for item in value4                {
                    let detail = Place()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
