//
//  FromAccountCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class FromAccountCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblAccountDescription: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAccountNumberIBAN: UILabel!
    
    func show(_ item: Account){
        let accountNumber = item.account
        print("Account: ",item.account)
        self.show(item.aliasName as String, owner: item.name as String, type: item.typeDescription as String, longAccountNumber: item.sinpe as String, accountNumber: accountNumber as String, amount: item.availableBalance
            , amountCurrency: item.currencySign as String)
    }
    
    fileprivate func show(_ accountDescription: String,owner: String, type: String, longAccountNumber:String, accountNumber:String,
                          amount:NSNumber, amountCurrency : String){
        lblAccountDescription.text = accountDescription
        lblOwner.text = owner
        //lblAccountType.text = type
        lblAccountNumberIBAN.text = longAccountNumber
        lblAmount.text = Helper.formatAmount(amount,currencySign: amountCurrency)
        
    }

}
