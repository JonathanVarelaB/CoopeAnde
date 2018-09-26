//
//  PasswordPoliciesResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PasswordPoliciesResponse: BaseResponse {
    
    var data: PasswordPolicies?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = PasswordPolicies()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
