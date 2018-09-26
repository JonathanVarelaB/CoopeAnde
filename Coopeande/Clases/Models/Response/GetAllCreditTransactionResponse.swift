//
//  GetAllCreditTransactionResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/16/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class GetAllCreditTransactionResponse: BaseResponse {
    
    var data: CreditTransactions?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = CreditTransactions()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
