//
//  StatementsRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class StatementsRequest: BaseRequest {
    
    var account: NSString = ""
    var numPage: NSNumber = 0
    var totalPage: NSNumber = 0
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        print("Cuenta seleccionada: ", self.account)
        let keys :[AnyObject] = ["account" as AnyObject, "numPage" as AnyObject,"totalPage" as AnyObject]
        let values :[AnyObject] = [self.account, self.numPage, self.totalPage]
        //data?.addEntriesFromDictionary(NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]))
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
        
    }
}
