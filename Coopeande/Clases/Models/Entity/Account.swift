//
//  Account.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Account: SelectableProduct{
    
    var account: NSString = ""
    var aliasName: NSString = ""
    var availableBalance: NSNumber = 0
    var currencySign: NSString = ""
    var name: NSString = ""
    var sinpe: NSString = ""
    var typeDescription: NSString = ""
    //destinationAccount
    var accountOrSinpe: NSString = ""
    var currencyTypeName: NSString = ""
    var currencyTypeId: NSString = ""
    var isDestination:Bool = false
    //walletAccount
    var phoneNumber: NSString = ""
    var walletId: NSString = ""
    var iban: NSString = ""
    
    var color: Int = 0
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value : AnyObject = data["account"] as AnyObject?
            {
                self.account = value.description as NSString
            }
            if let value1: AnyObject = data ["aliasName"] as AnyObject?
            {
                self.aliasName = value1.description as NSString
            }
            if let value2  = data["availableBalance"] as? Double
            {
                self.availableBalance = NSNumber(value: value2)
            }
            if let value3: AnyObject  = data["currencySign"] as AnyObject?
            {
                self.currencySign = value3.description as NSString
            }
            if let value4: AnyObject  = data["name"] as AnyObject?
            {
                self.name = value4.description as NSString
            }
            if let value5: AnyObject  = data["sinpe"] as AnyObject?
            {
                self.sinpe = value5.description as NSString
            }
            if let value6: AnyObject  = data["typeDescription"] as AnyObject?
            {
                self.typeDescription = value6.description as NSString
            }
            // para destinationAccount typeDescription viene como type
            if let value7: AnyObject  = data["type"] as AnyObject?
            {
                self.typeDescription = value7.description as NSString
            }
            if let value8: AnyObject  = data["currencyTypeId"] as AnyObject?
            {
                self.currencyTypeId = value8.description as NSString
            }
            if let value9: AnyObject  = data["currencyTypeName"] as AnyObject?
            {
                self.currencyTypeId = value9.description as NSString
            }
            if let value10: AnyObject  = data["accountOrSinpe"] as AnyObject?
            {
                self.accountOrSinpe = value10.description as NSString
                if(self.account == "")
                {
                    self.account = self.accountOrSinpe
                    
                }
            }
            //fwallet accounts
            if let value11: AnyObject  = data["phoneNumber"] as AnyObject?
            {
                self.phoneNumber = value11.description as NSString
            }
            if let value12: AnyObject  = data["walletId"] as AnyObject?
            {
                self.walletId = value12.description as NSString
            }
            if let value13: AnyObject  = data["ibanAccount"] as AnyObject?
            {
                self.iban = value13.description as NSString
            }
            
        }
    }
}
