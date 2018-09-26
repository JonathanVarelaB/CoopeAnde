//
//  LoginRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class LoginRequest: BaseRequest {
    var deviceId:NSString{
        return UUID().uuidString as NSString
    }
    var password:NSString = ""
    
    override func toJson() -> NSMutableDictionary?
    {
        let keys:[AnyObject] = ["deviceId" as AnyObject,"password" as AnyObject,"user" as AnyObject]
        let values:[AnyObject] = [self.deviceId,self.password,self.user]
        print("Device: ",self.deviceId," Usuario: ",self.user,"Contraseña: ",self.password)
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
}
