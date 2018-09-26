//
//  PaymentServicesResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PaymentServicesResponse: BaseResponse {
    
    var data: PaymentServices?
    
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = PaymentServices(count: 0, list: [])
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
