//
//  ServicioCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var lblProvider: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        self.btnCheckBox.layer.borderWidth = 1
        self.btnCheckBox.layer.borderColor = UIColor(red:0.84, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.btnCheckBox.layer.cornerRadius = 12.5
    }
    
    func show(_ item: PaymentService){
        self.show(item.aliasServiceName as String, companyName: item.companyName as String, isSelected: item.selected as Bool)
    }
    
    fileprivate func show(_ aliasName: String, companyName: String, isSelected: Bool){
        self.lblServiceTitle.text = aliasName
        self.lblProvider.text = companyName
        if isSelected {
            self.btnCheckBox.layer.backgroundColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0).cgColor
        }
        else{
            self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
