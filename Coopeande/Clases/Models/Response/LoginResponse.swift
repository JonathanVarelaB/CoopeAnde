//
//  LoginResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class LoginResponse: BaseResponse {
    var data:Login?
    override func fromJson(_ response: NSDictionary?)
    {
        super.fromJson(response)
        data = Login()
        if let detail = response
        {
            data?.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
}
