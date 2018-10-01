//
//  Accounts.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Accounts : EntityBase,  NSCopying {
    
    var count: NSNumber = 1
    var list: Array<Account> = []
    var colorIndex: Int = 0
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Accounts(count: count, list: list)
    }
    
    init(count: NSNumber, list: Array<Account>){
        self.count = count
        self.list = list
    }
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            if let value3 = data ["accountTotal"] as? NSNumber
            {
                self.count = value3
            }
            if let value4 : NSArray = data.object(forKey: "accountList") as? NSArray
            {
                list = []
                
                for item in value4
                {
                    let detail = Account()
                    detail.fromJson( item as? NSDictionary)
                    detail.color = self.colorIndex
                    list.append(detail)
                    self.colorIndex = (self.colorIndex < 4) ? (self.colorIndex + 1) : 0
                }
            }
            
            if let value5 = data ["walletAccountTotal"] as? NSNumber
            {
                self.count = value5
            }
            if let value6 : NSArray = data.object(forKey: "walletAccountList") as? NSArray
            {
                list = []
                
                for item in value6
                {
                    let detail = Account()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
            
            if let value7 = data ["walletAccountOriginTotal"] as? NSNumber
            {
                self.count = value7
            }
            if let value8 : NSArray = data.object(forKey: "walletAccountOriginList") as? NSArray
            {
                list = []
                
                for item in value8
                {
                    let detail = Account()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
            }
            
            
            
        }
    }
}
