//
//  TransferTypesResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferTypesResponse: BaseResponse {
    
    var data: TransferTypes?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = TransferTypes()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
