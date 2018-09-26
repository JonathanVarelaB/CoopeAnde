//
//  Contact.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Contact: SelectableProduct{
    
    var name: String = ""
    var phoneNumber: String = ""
    
    init(name: String, number: String){
        self.name = name
        self.phoneNumber = number.replacingOccurrences(of: "-", with: "").suffix(8).description
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value: AnyObject = data["name"] as AnyObject?{
                self.name = value.description
            }
            if let value: AnyObject = data ["phoneNumber"] as AnyObject?{
                self.phoneNumber = value.description
            }
        }
    }
    
}
