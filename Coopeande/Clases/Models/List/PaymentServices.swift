//
//  PaymentServices.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PaymentServices : EntityBase, NSCopying {
    
    var count: NSNumber = 1
    var list: Array<PaymentService> = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        return PaymentServices(count: count, list: list)
    }
    
    init(count: NSNumber, list: Array<PaymentService>){
        self.count = count
        self.list = list
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response {
            if let value3 = data ["paymentServiceByTypeTotal"] as? NSNumber{
                self.count = value3
                //self.count = 3
            }
            if let value4 : NSArray = data.object(forKey: "paymentServiceByTypeList") as? NSArray{
                list = []
                for item in value4 {
                    let detail = PaymentService()
                    detail.fromJson( item as? NSDictionary)
                    list.append(detail)
                }
                /*var pay1 = PaymentService()
                pay1.aliasServiceName = "TEST1"
                pay1.aliasTypeId = "12"
                pay1.companyName = "Tarela"
                var pay2 = PaymentService()
                pay2.aliasServiceName = "TEST2"
                pay2.aliasTypeId = "13"
                pay2.companyName = "Tarela"
                list.append(pay1)
                list.append(pay2)*/
            }
        }
    }
}

/*
 
 "paymentServiceByTypeTotal": 1,
 "paymentServiceByTypeList": [
 {
 "aliasTypeId": "4",
 "aliasServiceName": "CONCELUZ",
 "companyName": "EMPRESA SERVICIOS PUBLICOS DE HEREDIA"
 }
 ]
 
 */
