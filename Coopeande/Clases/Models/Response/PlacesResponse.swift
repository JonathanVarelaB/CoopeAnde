//
//  PlacesResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlacesResponse: BaseResponse {

    var data: Places?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = Places()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}

