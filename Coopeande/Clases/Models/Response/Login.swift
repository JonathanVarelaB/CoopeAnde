//
//  Login.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Login: EntityBase {
    var name:NSString = ""
    var token:NSString = ""

    override func fromJson(_ response: NSDictionary?)
    {
        if let data = response
        {
            if let value:AnyObject = data["name"] as AnyObject?
            {
                self.name = value.description as NSString
                self.name = NSString(string: self.name.replacingOccurrences(of: "\n", with: " ").description)
            }
            if let value1:AnyObject = data["token"] as AnyObject?
            {
                self.token = value1.description as NSString
            }
        }
    }
}
