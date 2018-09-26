//
//  SavingCalculatorResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class SavingCalculatorResponse: BaseResponse {
    
    var data: SavingCalculatorResult?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = SavingCalculatorResult()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
