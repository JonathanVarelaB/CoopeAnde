//
//  ReceiptServices.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
class ReceiptServices:EntityBase {
    
    var count: NSNumber = 0
    var list:   Array<ReceiptService> = []
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["paymentServiceDetailsTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "paymentServiceDetailsList") as? NSArray{
                list = []
                for item in value4 {
                    let detail = ReceiptService()
                    detail.fromJson(item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
}
