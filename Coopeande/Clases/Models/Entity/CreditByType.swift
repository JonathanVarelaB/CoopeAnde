//
//  CreditByType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditByType: SelectableProduct {
    
    var id: String = ""
    var alias: String = ""
    var owner: String = ""
    var description: String = ""
    var operation: String = ""
    var state: String = ""
    var isActive: Bool = false
    var balanceAmount: NSNumber = 0
    var interests: NSNumber = 0
    var pendingPolicy: Int = 0
    var pendingQuota: Int = 0
    var totalQuota: Int = 0
    var quotaAmount: NSNumber = 0
    var currencyName: String = ""
    var currencyId: String = ""
    var currencySign: String = ""
    var cutOffDate: Date? = nil
    var maxPaymentDate: Date? = nil
    var iban: String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["creditTypeId"] as? String{
                self.id = value
            }
            if let value = data ["aliasNameCredit"] as? String{
                self.alias = value
            }
            if let value = data ["name"] as? String{
                self.owner = value
            }
            if let value = data ["creditTypeDesc"] as? String{
                self.description = value
            }
            if let value = data ["operationId"] as? String{
                self.operation = value
            }
            if let value = data ["stateDesc"] as? String{
                self.state = value
            }
            if let value = data ["isActive"] as? Bool{
                self.isActive = value
            }
            if let value = data ["balanceAmount"] as? NSNumber{
                self.balanceAmount = value
            }
            if let value = data["interests"] as? NSNumber{
                self.interests = value
            }
            if let value = data ["pendingPolicy"] as? Int{
                self.pendingPolicy = value
            }
            if let value = data["pendingQuota"] as? Int{
                self.pendingQuota = value
            }
            if let value = data ["totalQuota"] as? Int{
                self.totalQuota = value
            }
            if let value = data["quotaAmount"] as? NSNumber{
                self.quotaAmount = value
            }
            if let value = data["currencyTypeName"] as? String{
                self.currencyName = value
            }
            if let value = data ["currencyTypeId"] as? String{
                self.currencyId = value
            }
            if let value = data ["currencySign"] as? String{
                self.currencySign = value
            }
            if let value = data ["cutOffDate"] as? String{
                //value = "2018-09-01T02:20:20"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let dateFromString = dateFormatter.date(from: value) {
                    self.cutOffDate = dateFromString
                }
            }
            if let value = data ["maxPaymentDate"] as? String{
                //value = "2018-09-30T02:20:20"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let dateFromString = dateFormatter.date(from: value) {
                    self.maxPaymentDate = dateFromString
                }
            }
            if let value = data ["ibanAccount"] as? String{
                self.iban = value
            }
        }
    }
    
}
