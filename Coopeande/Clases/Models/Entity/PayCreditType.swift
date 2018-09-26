//
//  PayCreditType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayCreditType: SelectableProduct {
    
    var id: String = ""
    var name: String = ""
    var pendingQuantity: NSNumber = 0
    var creditName: String = ""
    var creditAlias: String = ""
    var amount: String = ""
    var paymentDescription: String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["creditReceiveTypeId"] as? String{
                self.id = value
            }
            if let value = data ["creditReceiveTypeDesc"] as? String{
                self.name = value
            }
            if let value = data["pendingQuantity"] as? NSNumber{
                self.pendingQuantity = value
            }
            if let value = data ["creditName"] as? String{
                self.creditName = value
            }
            if let value = data ["creditAlias"] as? String{
                self.creditAlias = value
            }
            if let value = data ["amount"] as? String{
                self.amount = value
            }
            if let value = data ["paymentDescription"] as? String{
                self.paymentDescription = value
            }
        }
    }
    
}
