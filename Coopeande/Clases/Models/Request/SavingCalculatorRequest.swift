//
//  SavingCalculatorRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class SavingCalculatorRequest: BaseRequest {
    
    var currencyTypeId: String = ""
    var amount: Int = 0
    var beginMonth: Int = 0
    var beginYear: Int = 0
    var endMonth: Int = 0
    var endYear: Int = 0
    var interest: Int = 0
    var saveTypeId: String = ""
    var calculatorTypeId: String = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys :[AnyObject] = ["currencyTypeId" as AnyObject, "amount" as AnyObject,"beginMonth" as AnyObject,"beginYear" as AnyObject,"endMonth" as AnyObject, "endYear" as AnyObject, "interest" as AnyObject, "saveTypeId" as AnyObject, "calculatorTypeId" as AnyObject]
        let values :[AnyObject] = [self.currencyTypeId as AnyObject, self.amount as AnyObject, self.beginMonth as AnyObject, self.beginYear as AnyObject, self.endMonth as AnyObject, self.endYear as AnyObject, self.interest as AnyObject, self.saveTypeId as AnyObject, self.calculatorTypeId as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
}
