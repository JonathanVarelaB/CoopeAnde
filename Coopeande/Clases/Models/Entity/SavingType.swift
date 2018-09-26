//
//  SavingType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class SavingType: SelectableProduct {
    
    var typeId: String = ""
    var typeName: String = ""
    var interest: NSNumber = 0
    var minAmount: Int = 0
    var maxAmount: Int = 0
    var observations: String = ""
    var currencyTypeName: String = ""
    var currencyTypeId: String = ""
    var currencySign: String = ""
    var interestShow: String = ""

    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["typeId"] as? String{
                self.typeId = value
            }
            if let value = data ["typeName"] as? String{
                self.typeName = value
            }
            if let value = data ["interest"] as? NSNumber{
                self.interest = value
                self.interestShow = "Interés: " + Helper.formatAmount(self.interest) + "%"
            }
            if let value = data ["minAmount"] as? Int{
                self.minAmount = value
            }
            if let value = data ["maxAmount"] as? Int{
                self.maxAmount = (value < self.minAmount) ? self.minAmount : value
            }
            if let value = data ["observations"] as? String{
                self.observations = value
            }
            if let value = data ["currencyTypeName"] as? String{
                self.currencyTypeName = value
            }
            if let value = data ["currencyTypeId"] as? String{
                self.currencyTypeId = value
            }
            if let value = data ["currencySign"] as? String{
                self.currencySign = value
            }
        }
    }
    
}
