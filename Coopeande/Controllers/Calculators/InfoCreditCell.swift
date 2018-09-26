//
//  InfoCreditCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class InfoCreditCell: UITableViewCell {
    
    @IBOutlet weak var lblTypeCredit: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblSelectCredit: UILabel!
    @IBOutlet weak var lblTypeProduct: UILabel!
    
    
    func show(product: String, typeCredit: String, interest: String, currency: String, selectCredit: String){
        self.lblTypeProduct.text = product
        if product == "Cálculo" {
            self.lblInterest.font = UIFont.systemFont(ofSize: 13)
        }
        self.lblTypeCredit.text = typeCredit
        self.lblInterest.text = interest
        self.lblCurrency.text = currency
        self.lblSelectCredit.text = selectCredit
    }
    
}
