//
//  BeginDate.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class BeginDate : EntityBase {
    
    var month : NSNumber = 0
    var monthDesc : String = ""
    var year : NSNumber = 0
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["month"] as? NSNumber{
                self.month = value
            }
            if let value = data ["monthDesc"] as? String{
                self.monthDesc = value
            }
            if let value = data["year"] as? NSNumber{
                self.year = value
            }
        }
    }
    
}
