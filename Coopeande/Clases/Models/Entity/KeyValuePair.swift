//
//  KeyValuePair.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class KeyValuePair :EntityBase {
    
    var key: NSString = ""
    var value: NSString = ""
    var template: NSString = "item"
    
    override init ()
    {
        super.init()
    }
    init(key:NSString, value:NSString)
    {
        self.key = key
        self.value = value
    }
    init(key:NSString, value:NSString, template:NSString)
    {
        self.key = key
        self.value = value
        self.template = template
    }
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value: AnyObject  = data["key"] as AnyObject?
            {
                self.key = value.description as NSString
                if(self.key.isEqual(to: "<null>"))
                {
                    self.key = ""
                }
            }
            if let value1: AnyObject = data ["value"] as AnyObject?
            {
                self.value = value1.description as NSString
                if(self.value.isEqual(to: "<null>"))
                {
                    self.value = ""
                }
            }
        }
    }
}
