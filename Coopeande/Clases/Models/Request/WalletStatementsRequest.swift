//
//  WalletStatementsRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletStatementsRequest: BaseRequest {
    
    var walletId: String = ""
    var numPage: NSNumber = 0
    var totalPage: NSNumber = 0
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys: [AnyObject] = ["walletId" as AnyObject, "numPage" as AnyObject,"totalPage" as AnyObject]
        let values: [AnyObject] = [self.walletId as AnyObject, self.numPage, self.totalPage]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
