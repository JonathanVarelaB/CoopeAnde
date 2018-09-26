//
//  ChangePasswordRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ChangePasswordRequest: LoginRequest {
    
    var toPassword: NSString = ""
    
    override func toJson() ->  NSMutableDictionary?
    {
        let data = super.toJson()
        data?.setValue(toPassword, forKey: "newPassword")
        return data
        
    }
}
