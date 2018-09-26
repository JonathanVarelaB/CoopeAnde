//
//  SavingCalculatorResult.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class SavingCalculatorResult : EntityBase {
    
    var rate : NSNumber = 0
    var quota : NSNumber = 0
    var savingTypeName : String = ""
    var initPeriod : String = ""
    var endPeriod : String = ""
    var totalSaving : NSNumber = 0
    var noteTitle : String = ""
    var note : String = ""
    var currencySign : String = ""
    var currencyName : String = ""
    var currencyId : String = ""
    var rateShow : String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value  = data["interest"] as? NSNumber{
                self.rate = value
                self.rateShow = "Interés: " + Helper.formatAmount(self.rate) + "%"
            }
            if let value  = data["quotaAmount"] as? NSNumber{
                self.quota = value
            }
            if let value = data["saveTypeDesc"] as? String{
                self.savingTypeName = value
            }
            if let value = data["beginPeriodDesc"] as? String{
                self.initPeriod = value
            }
            if let value = data["endPeriodDesc"] as? String{
                self.endPeriod = value
            }
            if let value  = data["totalSave"] as? NSNumber{
                self.totalSaving = value
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
            if let value = data["currencyTypeName"] as? String{
                self.currencyName = value
            }
            if let value = data["currencyTypeId"] as? String{
                self.currencyId = value
            }
            
        }
    }
    
}
