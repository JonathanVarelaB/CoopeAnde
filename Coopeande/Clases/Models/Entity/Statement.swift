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
    var day: String = ""
    var month: String = ""
    var timeToShow: String = ""
    var dateGroup: String = ""
    
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
                let dateFormatter = DateFormatter()
                let calendar = Calendar.current
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let dateFromString = dateFormatter.date(from: self.transactionDate.description) {
                    self.date = dateFromString
                    self.day = calendar.component(.day, from: dateFromString).description
                    self.month = Helper.months[calendar.component(.month, from: dateFromString) - 1]
                    let today = dateFormatter.string(from: Date())
                    if self.transactionDate.description == today {
                        self.dateGroup = "Movimientos de Hoy"
                    }
                    else
                    {
                        let days = Int((dateFromString.timeIntervalSinceNow / 60 / 60 / 24).rounded(.up))
                        if days < 0 && days > -8 {
                            self.dateGroup = "Últimos 7 Días"
                        }
                        else{
                            let year = calendar.component(.year, from: dateFromString).description
                            self.dateGroup = self.month + " " + year
                        }
                    }
                }
            }
            if let value4: AnyObject = data ["transactionDesc"] as AnyObject?
            {
                self.transactionDesc = value4.description as NSString
            }
            if let value5: AnyObject = data ["transactionTime"] as AnyObject?
            {
                self.transactionTime = value5.description as NSString
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                if let date24 = dateFormatter.date(from: self.transactionTime.description){
                    dateFormatter.amSymbol = "a.m"
                    dateFormatter.pmSymbol = "p.m"
                    dateFormatter.dateFormat = "hh:mm a"
                    self.timeToShow = dateFormatter.string(from: date24)
                }
            }
            
            /*
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy";
            self.date = dateFormat.date(from: self.transactionDate as String);*/
        }
    }
    
    
}
