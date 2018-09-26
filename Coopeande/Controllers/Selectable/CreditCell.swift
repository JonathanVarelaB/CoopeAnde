//
//  CreditCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CreditCell: UITableViewCell {
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        self.btnCheckBox.layer.borderWidth = 1
        self.btnCheckBox.layer.borderColor = UIColor(red:0.84, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.btnCheckBox.layer.cornerRadius = 12.5
    }
    
    func show(product: String, type: String, interest: String, currency: String, isSelected: Bool){
        self.lblType.text = type
        if product == "calculo" {
            self.lblInterest.font = UIFont.boldSystemFont(ofSize: 15)
            self.lblInterest.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
        }
        self.lblInterest.text = interest
        self.lblCurrency.text = currency
        if isSelected {
            self.btnCheckBox.layer.backgroundColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0).cgColor
        }
        else{
            self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
