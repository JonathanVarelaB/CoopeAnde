//
//  MonthCreditself.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/9/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class MonthCreditCell: UICollectionViewCell {
    
    @IBOutlet weak var lblNumberMonths: UILabel!
    @IBOutlet weak var lblMeses: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    var select: Bool = false
    
    func show(creditMonth: CreditMonth){
        self.lblNumberMonths.text = creditMonth.month.description
        if creditMonth.selected {
            self.viewBackground.backgroundColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
            self.lblMeses.textColor = UIColor.white
            self.lblNumberMonths.textColor = UIColor.white
        }
        else{
            self.viewBackground.backgroundColor = UIColor.white
            self.lblMeses.textColor = UIColor.black
            self.lblNumberMonths.textColor = UIColor.black
        }
    }
}
