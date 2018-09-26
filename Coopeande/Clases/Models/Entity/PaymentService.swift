//
//  PaymentService.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PaymentService: SelectableProduct {
    
    var aliasTypeId: NSString = ""
    var aliasServiceName: NSString = ""
    var companyName: NSString = ""
    //var selected: Bool = false

    /*
     {
     "aliasTypeId": "4",
     "aliasServiceName": "CONCELUZ",
     "companyName": "EMPRESA SERVICIOS PUBLICOS DE HEREDIA"
     }
     */
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response{
            if let value : AnyObject = data["aliasTypeId"] as AnyObject?{
                self.aliasTypeId = value.description as NSString
            }
            if let value1: AnyObject = data ["aliasServiceName"] as AnyObject?{
                self.aliasServiceName = value1.description.capitalized as NSString
            }
            if let value2: AnyObject  = data["companyName"] as AnyObject?{
                self.companyName = value2.description as NSString
            }
        }
    }
}
