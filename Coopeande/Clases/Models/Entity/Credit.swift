//
//  Credit.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Credit : EntityBase {
    var alias : NSString = ""
    var owner : NSString = ""
    var type : NSString = ""
    var documentNumber : NSString = ""
    var state : NSString = ""
    var isActive  : Bool = false
    var interestRate : NSNumber = 0
    var fee : NSNumber = 0
    var balance : NSNumber = 0
    var outstandingPolicy : NSNumber = 0
    var outstandingFee : NSNumber = 0
    var loanTerm : NSNumber = 0
    var currencySign : NSString = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["aliasNameCredit"] as? NSString{
                self.alias = value
            }
            if let value1 = data ["name"] as? NSString{
                self.owner = value1
            }
            if let value2 = data["creditTypeDesc"] as? NSString{
                self.type = value2
            }
            if let value3 = data["operationId"] as? NSString{
                self.documentNumber = value3
            }
            if let value4 = data["stateDesc"] as? NSString{
                self.state = value4
            }
            if let value5  = data["isActive"] as? Bool{
                self.isActive = value5
            }
            if let value8  = data["interests"] as? NSNumber{
                self.interestRate = value8
            }
            if let value9  = data["quotaAmount"] as? NSNumber{
                self.fee = value9
            }
            if let value10  = data["balanceAmount"] as? NSNumber{
                self.balance = value10
            }
            if let value11  = data["pendingPolicy"] as? NSNumber{
                self.outstandingPolicy = value11
            }
            if let value12  = data["pendingQuota"] as? NSNumber{
                self.outstandingFee = value12
            }
            if let value13  = data["totalQuota"] as? NSNumber{
                self.loanTerm = value13
            }
            if let value14 = data["currencySign"] as? NSString{
                self.currencySign = value14
            }
        }
    }
}
