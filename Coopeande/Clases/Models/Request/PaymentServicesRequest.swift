//
//  PaymentServicesRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PaymentServicesRequest: BaseRequest {
    
    var aliasTypeId: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        data?.setValue(aliasTypeId, forKey: "aliasTypeId")
        return data
        
    }
}
