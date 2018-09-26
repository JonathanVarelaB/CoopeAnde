//
//  TransferConfirmResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TransferConfirmResponse: BaseResponse {
    
    var data: KeyValuePairs?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = KeyValuePairs()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
