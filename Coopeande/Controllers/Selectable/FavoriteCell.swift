//
//  FavoriteCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/21/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        self.btnCheckBox.layer.borderWidth = 1
        self.btnCheckBox.layer.borderColor = UIColor(red:0.84, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.btnCheckBox.layer.cornerRadius = 12.5
    }
    
    func set(contact: Contact){
        self.lblName.text = contact.name
        self.lblNumber.text = Helper.formatPhone(text: contact.phoneNumber)
        if contact.selected {
            self.btnCheckBox.layer.backgroundColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0).cgColor
        }
        else{
            self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
