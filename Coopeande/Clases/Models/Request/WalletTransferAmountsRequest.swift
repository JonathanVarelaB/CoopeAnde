//
//  WalletTransferAmountsRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletTransferAmountsRequest : BaseRequest {
    
    var maxAmountBySMS: Int = 0
    var maxAmountByApplication: Int = 0
    var isSendNotificationSMS: Bool = false
    var email: String = ""
    var isSendNotificationEmail: Bool = false
    
    override func toJson() ->  NSMutableDictionary?{
        let data = super.toJson()
        let keys: [AnyObject] = ["maxAmountBySMS" as AnyObject, "maxAmountByApplication" as AnyObject, "isSendNotificationSMS" as AnyObject,"email" as AnyObject, "isSendNotificationEmail" as AnyObject]
        let values: [AnyObject] = [self.maxAmountBySMS as AnyObject, self.maxAmountByApplication as AnyObject, self.isSendNotificationSMS as AnyObject, self.email as AnyObject, self.isSendNotificationEmail as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
    
}

