//
//  PayCreditTypeResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayCreditTypeResponse: BaseResponse {
    
    var data: PayCreditTypes?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = PayCreditTypes(count: 0, list: [])
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
