//
//  TransferType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferType: SelectableProduct {
    
    var commission: NSDecimalNumber?
    var id: NSString = ""
    var name: NSString = ""
    var currencySign: NSString = ""
    var image: UIImage? = nil
    var color: Int = 0
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3: NSNumber = data ["commission"] as? NSNumber{
                self.commission = NSDecimalNumber(floatLiteral: Double(value3.floatValue))
            }
            if let value4: AnyObject = data ["id"]  as AnyObject?{
                self.id = value4.description as NSString
            }
            if let value: AnyObject = data ["name"] as AnyObject?{
                self.name = value.description as NSString
            }
            if let value5: AnyObject  = data["currencySign"] as AnyObject?{
                self.currencySign = value5.description as NSString
            }
        }
    }

}

class TransferReceipt{
    var transferType : String = ""
    var transferAmount : NSDecimalNumber = 0
    var transferComission : NSDecimalNumber = 0
    var transferFrom : String = ""
    var transferFromAcountNumber : String = ""
    var transferTo : String = ""
    var transferToAcountNumber : String = ""
    var transferDescription : String = ""
    var currency : String = ""
}
