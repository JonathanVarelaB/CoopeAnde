//
//  PayCreditResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PayCreditResponse: BaseResponse {
    
    //var data: KeyValuePairs?
    var data: ReceiptService?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = ReceiptService()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
