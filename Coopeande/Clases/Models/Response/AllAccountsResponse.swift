//
//  AllAccountsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class AllAccountsResponse: BaseResponse {
    
    var data: Accounts?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = Accounts(count: 0, list: [])
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
