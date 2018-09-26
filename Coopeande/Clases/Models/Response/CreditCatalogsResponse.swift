//
//  CreditCatalogsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditCatalogsResponse: BaseResponse {
    
    var info: CreditInfo?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        info = CreditInfo(limits: [], types: [])
        if let detail = response {
            info!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
