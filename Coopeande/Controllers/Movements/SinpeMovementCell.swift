//
//  SinpeMovementCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/25/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class SinpeMovementCell: UITableViewCell {

    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }

    func show(mov: Statement, currency: String){
        self.lblNumber.text = mov.documentString.description
        self.lblAmount.text = Helper.formatAmount(mov.totalTransaction, currencySign: currency)
        self.lblType.text = mov.transactionDesc.description
        self.lblDay.text = mov.day
        self.lblMonth.text = mov.month
        self.lblHour.text = mov.timeToShow
    }

}
