//
//  Statement.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Statement : EntityBase {
    
    var date: Date?
    var document: NSString = ""
    var documentString: NSString = ""
    var totalTransaction: NSNumber = 0
    var transactionDate: NSString = ""
    var transactionDesc: NSString = ""
    var transactionTime: NSString = ""
    
    override func fromJson(_ response:NSDictionary?)
    {
        if let data = response
        {
            
            if let value1 = data ["document"] as? NSNumber
            {
                self.document = value1.stringValue as NSString
            }
            
            if let value1 = data ["document"] as? NSString
            {
                self.documentString = value1
            }
            
            if let value2 = data ["totalTransaction"] as? NSNumber
            {
                self.totalTransaction = value2
            }
            if let value3: AnyObject = data ["transactionDate"] as AnyObject?
            {
                self.transactionDate = value3.description as NSString
            }
            if let value4: AnyObject = data ["transactionDesc"] as AnyObject?
            {
                self.transactionDesc = value4.description as NSString
            }
            if let value5: AnyObject = data ["transactionTime"] as AnyObject?
            {
                self.transactionTime = value5.description as NSString
            }
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy";
            self.date = dateFormat.date(from: self.transactionDate as String);
        }
    }
    
    
}
