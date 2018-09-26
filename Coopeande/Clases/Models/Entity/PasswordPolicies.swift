//
//  PasswordPolicies.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PasswordPolicies  : EntityBase{
    
    var msgNote: NSString = ""
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            
            if let value1: AnyObject = data ["msgNote"] as AnyObject?
            {
                self.msgNote = value1.description as NSString
            }
        }
    }
}
