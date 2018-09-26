//
//  TransferAccounts.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferAccounts : Accounts {
    
    var accountFromCount: NSNumber = 0
    var accountTocount: NSNumber = 0
    
    var destinationAccounts : Array<Account> = []
    override func fromJson(_ response:NSDictionary?)
    {
        self.count = 0
        self.list = []
        self.destinationAccounts = []
        
        if let data = response
        {
            // Account from
            //            if let value3 = data ["originAccountTotal"] as? NSNumber
            //            {
            //                self.count = value3
            //            }
            if let value4 : NSArray = data.object(forKey: "originAccountList") as? NSArray
            {
                for item in value4
                {
                    let Fromdetail = Account()
                    Fromdetail.fromJson( item as? NSDictionary)
                    list.append(Fromdetail)
                }
            }
            // Account To
            //            if let value5 = data ["destinationAccountTotal"] as? NSNumber
            //            {
            //                self.count = self.count + value5
            //            }
            if let value6 : NSArray = data.object(forKey: "destinationAccountList") as? NSArray
            {
                for item in value6
                {
                    let Todetail = Account()
                    Todetail.isDestination = true
                    Todetail.fromJson( item as? NSDictionary)
                    destinationAccounts.append(Todetail)
                }
            }
        }
    }
    
}
