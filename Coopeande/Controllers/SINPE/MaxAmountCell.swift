//
//  MaxAmountCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class MaxAmountCell: UITableViewCell {
    
    @IBOutlet weak var txtAmount: UITextField!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.txtAmount.layer.borderWidth = 0.7
        self.txtAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtAmount.layer.cornerRadius = 4
        self.txtAmount.leftViewMode = UITextFieldViewMode.always
        let labelFrame = CGRect(x: 0, y: 0, width: 20, height: 40)
        let label = UILabel(frame: labelFrame)
        //label.text = "   ¢"
        label.font = self.txtAmount.font
        label.textColor = self.txtAmount.textColor
        self.txtAmount.leftView = label
    }
    
}
