//
//  TicketCRM.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class TicketCRM : EntityBase {
    
    var ticketId: NSString = ""
    var confirmationMessage: NSString = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data ["ticketId"] as? NSString{
                self.ticketId = value
            }
            if let value1 = data ["confirmationMessage"] as? NSString{
                self.confirmationMessage = value1
            }
        }
    }
    
}
