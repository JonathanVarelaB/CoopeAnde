//
//  PreLoginRequest.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import AdSupport

class PreLoginRequest:LoginRequest {
    
    var includeParent:Bool = false
    
    override func toJson() ->  NSMutableDictionary?
    {
        if(includeParent)
        {
            let data = super.toJson()
            //data?.addEntriesFromDictionary(self.getIOSData())
            print("Datos", self.getIOSData())
            data?.addEntries(from: self.getIOSData() as! [AnyHashable : Any])
            return data
        }
        //print(self.getIOSData())
        return self.getIOSData()
    }
}
