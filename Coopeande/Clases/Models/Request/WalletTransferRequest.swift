//
//  WalletTransferRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletTransferRequest: BaseRequest {
    
    var walletId: NSString = ""
    var aliasNameOrigin: NSString = ""
    var nameAccountOrigin: NSString = ""
    var destinationPhoneNumber: String = ""
    var reason: NSString = ""
    var total: Int = 0
    
    override func toJson() ->  NSMutableDictionary? {
        let data = super.toJson()
        let keys: [AnyObject] = ["walletId" as AnyObject, "aliasNameOrigin" as AnyObject,"nameAccountOrigin" as AnyObject, "destinationPhoneNumber" as AnyObject,"reason" as AnyObject,"total" as AnyObject]
        let values: [AnyObject] = [self.walletId, self.aliasNameOrigin, self.nameAccountOrigin, self.destinationPhoneNumber as AnyObject, self.reason, self.total as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}
