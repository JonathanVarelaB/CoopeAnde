
//  Account.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Service : EntityBase {
    
    var aliasTypeId: NSString = ""
    var name: NSString = ""
    var description: NSString = ""
    var image: NSString = ""
    var color: Int = 0
    
    /*
     "aliasTypeId": "3",
     "name": "AGUA",
     "description": "Pago de Servicio",
     "image": "agua.png"
     */
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response{
            if let value : AnyObject = data["aliasTypeId"] as AnyObject?{
                self.aliasTypeId = value.description as NSString
            }
            if let value1: AnyObject = data ["name"] as AnyObject?{
                self.name = value1.description as NSString
            }
            if let value2: AnyObject  = data["description"] as AnyObject?{
                self.description = value2.description as NSString
            }
            if let value3: AnyObject  = data["image"] as AnyObject?{
                self.image = value3.description.lowercased() as NSString
            }
        }
    }
}
