//
//  WalletTransferAmountStatement.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletTransferAmountStatement : EntityBase {
    
    var maxAmountByApplication :NSNumber = 0
    var maxAmountBySMS :NSNumber = 0
    var currencySign :NSString = ""
    var isSendNotificationSMS : Bool = false
    var email :NSString = ""
    var isSendNotificationEmail : Bool = false
    var info :NSString = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value1 = data ["maxAmountByApplication"] as? NSNumber{
                self.maxAmountByApplication = value1
            }
            if let value2 = data ["maxAmountBySMS"] as? NSNumber{
                self.maxAmountBySMS = value2
            }
            if let value3 = data ["currencySign"] as? NSString{
                self.currencySign = value3
            }
            if let value4 = data ["isSendNotificationSMS"] as? Bool{
                self.isSendNotificationSMS = value4
            }
            if let value5 = data ["email"] as? NSString{
                self.email = value5
            }
            if let value6 = data ["isSendNotificationEmail"] as? Bool{
                self.isSendNotificationEmail = value6
            }
            if let value7 = data ["info"] as? NSString{
                self.info = value7
            }
        }
    }
    
}
