//
//  ChangePasswordRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ChangePasswordRequest: LoginRequest {
    
    var newPassword: String = "";
    var retypePass: String = "";
    
    override func toJson() -> NSMutableDictionary? {
        let data = super.toJson()
        let keys:[AnyObject] = ["newPassword" as AnyObject, "retypePass" as AnyObject]
        let values:[AnyObject] = [self.newPassword as AnyObject, self.retypePass as AnyObject]
        data?.addEntries(from: NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying]) as! [AnyHashable : Any])
        return data
    }
}
