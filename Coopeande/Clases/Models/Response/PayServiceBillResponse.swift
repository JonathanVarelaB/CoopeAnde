//
//  PayServiceBillResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/3/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

import Foundation
class PayServiceBillResponse: BaseResponse {
    
    //var data: PaidBill?
    var data: ReceiptService?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = ReceiptService()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
