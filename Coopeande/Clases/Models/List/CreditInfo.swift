//
//  CreditInfo.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditInfo: EntityBase {
    
    var limits: Array<CreditMonth> = []
    var types: Array<CreditType> = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        return CreditInfo(limits: limits, types: types)
    }
    
    init(limits: Array<CreditMonth>, types: Array<CreditType>){
        self.limits = limits
        self.types = types
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value : Array<NSString> = data.object(forKey: "creditTimeLimitList") as? Array<NSString>{
                self.limits = []
                for item in value{
                    //self.limits.append(Int(item as String)!)
                    let detail = CreditMonth()
                    detail.setMonth(month: Int(item as String)!)
                    self.limits.append(detail)
                }
            }
            if let value : NSArray = data.object(forKey: "creditTypeList") as? NSArray{
                self.types = []
                for item in value{
                    let detail = CreditType()
                    detail.fromJson( item as? NSDictionary)
                    self.types.append(detail)
                }
            }
        }
    }
}
