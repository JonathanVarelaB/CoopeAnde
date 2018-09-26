//
//  PlaceCategoryResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceCategoryResponse: BaseResponse {
    var data: PlacesCategories?
    override func fromJson(_ response:NSDictionary?)
    {
        
        super.fromJson(response)
        data = PlacesCategories()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
