//
//  AffiliatePhoneCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class AffiliatePhoneCell: UITableViewCell {
    
    @IBOutlet weak var lblNumberPhone: UILabel!
    @IBOutlet weak var lblIban: UILabel!
    
    func set(account: Account){
        self.lblNumberPhone.text = "Teléfono: " + Helper.formatPhone(text: account.phoneNumber.description)
        self.lblIban.text = "Cuenta IBAN " + account.iban.description
    }
    
}
