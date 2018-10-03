//
//  TicketCRMResponse.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TicketCRMResponse: BaseResponse {
    
    var data: TicketCRM?
    
    override func fromJson(_ response:NSDictionary?){
        super.fromJson(response)
        data = TicketCRM()
        if let ticket = response {
            data!.fromJson(ticket.object(forKey: "data") as? NSDictionary)
        }
    }
    
}
