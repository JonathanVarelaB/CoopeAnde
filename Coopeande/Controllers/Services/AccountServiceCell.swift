//
//  AccountServiceCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AccountServiceCell: UITableViewCell {

    @IBOutlet weak var viewAccountService: UIView!
    @IBOutlet weak var lblIbanDesc: UILabel!
    @IBOutlet weak var lblIbanNumber: UILabel!
    @IBOutlet weak var lblAccountTotal: UILabel!
    @IBOutlet weak var lblSelectAccount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    func show(accountDesc: String, ibanNumber: String, accountTotal: NSNumber, selectAccount: String, currencySign: String, customTitle: String = ""){
        self.lblIbanDesc.text = accountDesc
        self.lblSelectAccount.text = selectAccount
        self.lblIbanNumber.text = ibanNumber
        self.lblAccountTotal.text = ""
        if currencySign != ""{
            self.lblAccountTotal.text = Helper.formatAmount(accountTotal, currencySign: currencySign)
        }
        if customTitle != ""{
            self.lblTitle.text = customTitle
        }
    }

}
