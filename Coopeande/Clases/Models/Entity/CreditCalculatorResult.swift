//
//  CreditCalculatorResult.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditCalculatorResult : EntityBase {
    
    var rate: NSNumber = 0
    var quota: NSNumber = 0
    var creditTypeName: String = ""
    var periodDescription: String = ""
    var currencyName: String = ""
    var amount: NSNumber = 0
    var noteTitle: String = ""
    var note: String = ""
    var currencySign: String = ""
    var rateShow: String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["interest"] as? NSNumber{
                self.rate = value
                self.rateShow = "Interés: " + Helper.formatAmount(self.rate) + "%"
            }
            if let value  = data["quotaAmount"] as? NSNumber{
                self.quota = value
            }
            if let value = data["creditTypeDesc"] as? String{
                self.creditTypeName = value
            }
            if let value = data["periodDesc"] as? String{
                self.periodDescription = value
                if self.periodDescription.lowercased().range(of: "meses") == nil {
                    self.periodDescription = self.periodDescription + " Meses"
                }
            }
            if let value = data["currencyDesc"] as? String{
                self.currencyName = value
            }
            if let value = data["amount"] as? NSNumber{
                self.amount = value
            }
            if let value = data["noteTitle"] as? String{
                self.noteTitle = value
            }
            if let value = data["noteDesc"] as? String{
                self.note = value
            }
            if let value = data["currencySign"] as? String{
                self.currencySign = value
            }
        }
    }
}
