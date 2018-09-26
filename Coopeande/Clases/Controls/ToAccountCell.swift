//
//  ToAccountCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ToAccountCell: UITableViewCell {

    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    }

    @IBOutlet weak var lblAccountDescription: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblAccountNumberIBAN: UILabel!
    
    func show(item: Account)
{
    self.show(aliasName: item.aliasName as String, name: item.name as String, typeDescription: item.typeDescription as String, accountOrSinpe: item.accountOrSinpe as String)
    }
    
    private func show(aliasName: String,name: String, typeDescription: String, accountOrSinpe:String){
    
    lblAccountDescription.text = aliasName
    lblOwner.text = name
    //lblType.text = typeDescription
    lblAccountNumberIBAN.text = accountOrSinpe
    //lblDescription.text = accountOrSinpe.length == 17 ? "Cuenta Cliente" : "Nº Cuenta"
    
    }
    
    
}
