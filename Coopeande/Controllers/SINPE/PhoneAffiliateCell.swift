//
//  PhoneAffiliateCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PhoneAffiliateCell: UITableViewCell {
    
    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func show(select: String, phoneNumber: String){
        self.lblSelect.text = select
        self.lblPhoneNumber.text = Helper.formatPhone(text: phoneNumber)
    }
    
}
