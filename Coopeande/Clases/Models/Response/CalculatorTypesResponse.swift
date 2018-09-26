//
//  CalculatorTypesResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CalculatorTypesResponse: BaseResponse {
    
    var data: CalculatorTypes?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = CalculatorTypes(calculation: [], saving: [])
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
