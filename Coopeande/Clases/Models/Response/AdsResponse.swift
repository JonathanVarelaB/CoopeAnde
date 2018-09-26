//
//  AdsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
class AdsResponse: BaseResponse {
    
    var data: Adsenses?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = Adsenses()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
