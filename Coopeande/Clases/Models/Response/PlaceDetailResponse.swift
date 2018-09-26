//
//  PlaceDetailResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceDetailResponse: BaseResponse {
    
    var data: PlaceDetail?
    override func fromJson(_ response:NSDictionary?)
    {
        super.fromJson(response)
        data = PlaceDetail()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
