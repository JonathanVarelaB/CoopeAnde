//
//  AccountCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AccountCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblAAmount: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblOwnerAccount: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    
    
    
    func show(_ item: Account)
    {
        
        let accountNumber = item.account
        print("Account: ",item.account)
        self.show(item.aliasName as String, owner: item.name as String, type: item.typeDescription as String, longAccountNumber: item.sinpe as String, accountNumber: accountNumber as String, amount: item.availableBalance
            , amountCurrency: item.currencySign as String)
    }
    
    fileprivate func show(_ accountDescription: String,owner: String, type: String, longAccountNumber:String, accountNumber:String,
                          amount:NSNumber, amountCurrency : String){
        
        //lblAccountDescription.text = accountDescription
        lblOwnerAccount.text = owner
        lblAccountType.text = type
        lblAccountNumber.text = longAccountNumber
        //tvAccountNumber.text = accountNumber
        lblAAmount.text = Helper.formatAmount(amount,currencySign: amountCurrency)
        
    }
    
}
