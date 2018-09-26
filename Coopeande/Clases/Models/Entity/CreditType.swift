//
//  CreditType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditType: SelectableProduct {
    
    var id: String = ""
    var name: String = ""
    var imageId: String = ""
    var rate: NSNumber = 0
    var maxAmount: Int = 0
    var minAmount: Int = 0
    var maxPeriod: Int = 0
    var minPeriod: Int = 0
    var currencyName : String = ""
    var currencyId : String = ""
    var currencySign : String = ""
    var rateShow: String = ""
    var color: Int = 0
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["typeId"] as? String{
                self.id = value
            }
            if let value = data ["typeName"] as? String{
                self.name = value
            }
            if let value = data ["imageId"] as? String{
                self.imageId = value.lowercased()
            }
            if let value = data["interest"] as? NSNumber{
                self.rate = value
                self.rateShow = "Interés: " + Helper.formatAmount(self.rate) + "%"
            }
            if let value = data ["maxPeriod"] as? Int{
                self.maxPeriod = value
            }
            if let value = data["minPeriod"] as? Int{
                self.minPeriod = value
            }
            if let value = data ["maxAmount"] as? Int{
                self.maxAmount = value
            }
            if let value = data["minAmount"] as? Int{
                self.minAmount = value
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
        }
    }
    
}
