//
//  AllCreditsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditTypesByUserResponse: BaseResponse {
    
    var data: CreditTypesByUser?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = CreditTypesByUser()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
