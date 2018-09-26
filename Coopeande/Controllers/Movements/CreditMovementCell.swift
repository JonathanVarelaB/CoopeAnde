//
//  CreditMovementCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CreditMovementCell: UITableViewCell {
    
    @IBOutlet weak var lblQuota: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    @IBOutlet weak var lblDocument: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblMoratorium: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func show(quota: NSNumber, main: NSNumber, interest: NSNumber, moratorium: NSNumber, others: NSNumber, document: String, amount: NSNumber, day: String, month: String, currency: String){
        self.lblQuota.text = Helper.formatAmount(quota, currencySign: currency)
        self.lblMain.text = Helper.formatAmount(main, currencySign: currency)
        self.lblInterest.text = Helper.formatAmount(interest, currencySign: currency)
        self.lblMoratorium.text = Helper.formatAmount(moratorium, currencySign: currency)
        self.lblOthers.text = Helper.formatAmount(others, currencySign: currency)
        self.lblDocument.text = document
        self.lblAmount.text = Helper.formatAmount(amount, currencySign: currency)
        self.lblDay.text = day
        self.lblMonth.text = month
    }
}

