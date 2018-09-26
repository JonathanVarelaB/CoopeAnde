//
//  BaseResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class BaseResponse: EntityBase {
    
    var code:NSString = ""
    var isSuccess:Bool = false
    var message:NSString = ""
    
    override func fromJson(_ response: NSDictionary?) {
        if let data = response
        {
            if let value3 = data["code"] as? NSString
            {
                self.code = value3
            }
            if let value4 = data["isSuccessful"] as? Bool
            {
                self.isSuccess = value4
            }
            if let value = data["description"] as? NSString
            {
                self.message = value
            }
        }
    }
}
