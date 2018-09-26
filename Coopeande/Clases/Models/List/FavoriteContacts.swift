//
//  FavoriteContacts.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class FavoriteContacts: EntityBase {
    
    var count: NSNumber = 0
    var list: Array<Contact> = []
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data ["count"] as? NSNumber{
                self.count = value
            }
            if let value: NSArray = data.object(forKey: "list") as? NSArray{
                list = []
                for item in value{
                    let detail = Contact(name: "", number: "")
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
    
}
