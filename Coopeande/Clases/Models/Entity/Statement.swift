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
                dateFormatter.dateFormat = "dd/MM/yyyy" // SINPE
                if let dateFromString = dateFormatter.date(from: self.transactionDate.description) {
                    self.setFormatDate(date: dateFromString)
                }
                else{
                    //self.transactionDate = NSString(string: self.transactionDate.replacingOccurrences(of: " TT", with: ""))
                    self.transactionDate = NSString(string: self.transactionDate.description.prefix(10).description)
                    print(self.transactionDate)
                    dateFormatter.dateFormat = "dd/MM/yyyy" // Transfer
                    if let dateFromString = dateFormatter.date(from: self.transactionDate.description) {
                        self.setFormatDate(date: dateFromString)
                    }
                }
            }
            if let value4: AnyObject = data ["transactionDesc"] as AnyObject?
            {
                self.transactionDesc = value4.description as NSString
                self.transactionDesc = (self.transactionDesc == "NC" || self.transactionDesc == "CRE")
                    ? "Crédito"
                    : (self.transactionDesc == "ND" || self.transactionDesc == "DEB")
                    ? "Débito"
                    : self.transactionDesc
            }
            if let value5: AnyObject = data ["transactionTime"] as AnyObject?
            {
                self.transactionTime = value5.description as NSString
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss" // SINPE
                if let date24 = dateFormatter.date(from: self.transactionTime.description){
                    self.setFormatTime(date24: date24)
                }
                else{
                    self.transactionTime = NSString(string: self.transactionTime.replacingOccurrences(of: " TT", with: ""))
                    dateFormatter.dateFormat = "HH:mm" // Transfer
                    if let date24 = dateFormatter.date(from: self.transactionTime.description){
                        self.setFormatTime(date24: date24)
                    }
                }
            }
        }
    }
    
    func setFormatTime(date24: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "a.m"
        dateFormatter.pmSymbol = "p.m"
        dateFormatter.dateFormat = "hh:mm a"
        self.timeToShow = dateFormatter.string(from: date24)
    }
    
    func setFormatDate(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let calendar = Calendar.current
        self.date = date
        self.day = calendar.component(.day, from: date).description
        self.day = (self.day.count == 1) ? "0" + self.day : self.day
        self.month = Helper.months[calendar.component(.month, from: date) - 1]
        let today = dateFormatter.string(from: Date())
        if self.transactionDate.description == today {
            self.dateGroup = "Movimientos de hoy"
        }
        else
        {
            let days = Int((date.timeIntervalSinceNow / 60 / 60 / 24).rounded(.up))
            if days < 0 && days > -8 {
                self.dateGroup = "Últimos 7 Días"
            }
            else{
                let year = calendar.component(.year, from: date).description
                self.dateGroup = self.month + " " + year
            }
        }
    }
    
}
