//
//  Statements.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class Statements: EntityBase {
    
    var count: NSNumber = 0
    var list: Array<Statement> = []
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value3 = data ["transactionTotal"] as? NSNumber{
                self.count = value3
            }
            if let value4: NSArray = data.object(forKey: "transactionList") as? NSArray{
                list = []
                for item in value4{
                    let detail = Statement()
                    detail.fromJson( item  as? NSDictionary)
                    list.append(detail)
                }
            }
        }
    }
    
}
