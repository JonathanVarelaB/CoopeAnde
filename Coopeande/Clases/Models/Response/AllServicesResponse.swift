//
//  AllServicesResponse.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class AllServicesResponse: BaseResponse {
    
    var data: Services?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = Services()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
