//
//  TransferAccountsRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferAccountsRequest: BaseRequest {
    
    var transferTypeId: String = ""
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        data?.setValue(transferTypeId, forKey: "transferTypeId")
        return data
        
    }
}
