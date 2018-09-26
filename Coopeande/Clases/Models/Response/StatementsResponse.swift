//
//  StatementsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class StatementsResponse: BaseResponse {
    
    var data: Statements?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = Statements()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
