//
//  BaseRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class BaseRequest: EntityBase {
    var token:NSString = ""
    var user:NSString = ""
    
    override func toJson() -> NSMutableDictionary?
    {
        let keys:[AnyObject] = ["token" as AnyObject, "user" as AnyObject]
        let values:[AnyObject] = [self.token,self.user]
        
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
    
    func getIOSData() -> NSMutableDictionary
    {
        let keys:[AnyObject] = ["operativeSystem" as AnyObject,"version" as AnyObject]
        let appVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let values:[AnyObject] = ["IOS" as AnyObject,appVersionString as AnyObject]
        return NSMutableDictionary(objects: values, forKeys: keys as! [NSCopying])
    }
    
}
