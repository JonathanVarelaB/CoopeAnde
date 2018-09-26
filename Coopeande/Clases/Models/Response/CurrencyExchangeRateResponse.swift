//
//  CurrencyExchangeRateResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 30/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CurrencyExchangeRateResponse: BaseResponse {
    
    var data: Currencies?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = Currencies()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
