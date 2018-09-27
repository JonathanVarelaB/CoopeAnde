//
//  WalletAccountInactivateRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation


class WalletAccountInactivateRequest: BaseRequest {
    
    var walletId: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys: [AnyObject] = ["walletId" as AnyObject]
        let values: [AnyObject] = [self.walletId]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying] ) as! [AnyHashable : Any])
        return data
    }
    
}

