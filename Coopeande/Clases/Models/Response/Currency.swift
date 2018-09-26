//
//  Currency.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 30/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Currency : EntityBase {
    
    var exchangeSign: NSString = ""
    var name: NSString = ""
    var purchase: NSNumber=0
    var sales: NSNumber=0
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value: AnyObject  = data["exchangeSign"] as AnyObject?
            {
                self.exchangeSign = value.description as NSString
            }
            if let value1: AnyObject = data ["name"] as AnyObject?
            {
                self.name = value1.description as NSString
            }
            if let value2  = data["purchaseValue"] as? Double
            {
                self.purchase = NSNumber(value: value2)
            }
            if let value3  = data["salesValue"] as? Double
            {
                self.sales = NSNumber(value: value3)
            }
        }
    }
}
