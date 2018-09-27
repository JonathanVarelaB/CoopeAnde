//
//  WalletTransferAmountsResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class WalletTransferAmountsResponse: BaseResponse {
    
    var data: WalletTransferAmountStatement?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = WalletTransferAmountStatement()
        if let detail = response {
            data!.fromJson(detail.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
