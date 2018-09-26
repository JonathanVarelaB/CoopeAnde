//
//  CreditByTypeResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditByTypeResponse: BaseResponse {
    
    var data: CreditsByType?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = CreditsByType()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
