//
//  EntityBase.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

open class EntityBase
{
    func getJson() -> [String:AnyObject]?
    {
        return nil
    }
    func toJson() -> NSMutableDictionary?
    {
        return nil
    }
    open func fromJson(_ response:NSDictionary?)
    {}
    var isEmpty:Bool = false
    
}
