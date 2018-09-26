//
//  ReceiptDetailServiceResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ReceiptDetailServiceResponse: BaseResponse {
    
    var data: ReceiptServices! = nil
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = ReceiptServices()
        if let detail = response {
            data.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
