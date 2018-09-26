//
//  CreditTransaction.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/16/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditTransaction: EntityBase {
    
    var transactionDate: String = ""
    var quota: NSNumber = 0
    var main: NSNumber = 0
    var interest: NSNumber = 0
    var moratorium: NSNumber = 0
    var other: NSNumber = 0
    var document: String = ""
    var totalBalance: NSNumber = 0
    var operationId: String = ""
    var day: String = ""
    var month: String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data ["operationId"] as? String{
                self.operationId = value
            }
            if let value = data ["datetimeTransaction"] as? String{
                self.transactionDate = value
                let dateFormatter = DateFormatter()
                let calendar = Calendar.current
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                if let dateFromString = dateFormatter.date(from: self.transactionDate) {
                    self.day = calendar.component(.day, from: dateFromString).description
                    self.month = Helper.months[calendar.component(.month, from: dateFromString) - 1]
                }
            }
            if let value = data ["ammountQuota"] as? NSNumber{
                self.quota = value
            }
            if let value = data ["ammountMain"] as? NSNumber{
                self.main = value
            }
            if let value = data ["ammountInterest"] as? NSNumber{
                self.interest = value
            }
            if let value = data ["ammountMoratorium"] as? NSNumber{
                self.moratorium = value
            }
            if let value = data ["ammountOther"] as? NSNumber{
                self.other = value
            }
            if let value = data ["document"] as? String{
                self.document = value
            }
            if let value = data ["totalBalance"] as? NSNumber{
                self.totalBalance = value
            }
        }
    }
    
    
}
