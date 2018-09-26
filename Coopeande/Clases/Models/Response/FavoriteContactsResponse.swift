//
//  FavoriteContactsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class FavoriteContactsResponse: BaseResponse {
    
    var data: FavoriteContacts?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = FavoriteContacts()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
