//
//  AccountCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class AccountCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblSaldoActual: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAlias: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblIban: CopyableLabel!
    @IBOutlet weak var imgPlus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.layer.cornerRadius = 5
    }
    
    func show(account: Account, color: UIColor, image: UIImage){
        self.lblSaldoActual.textColor = color
        self.lblAmount.textColor = color
        self.lblAmount.text = Helper.formatAmount(account.availableBalance, currencySign: account.currencySign.description)
        self.lblType.text = account.typeDescription.description
        self.lblAlias.text = account.aliasName.description
        self.lblOwner.text = account.name.description
        self.lblIban.text = account.iban.description
        self.imgPlus.image = image
    }
    
}
