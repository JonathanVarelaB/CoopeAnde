//
//  DetailReceiptCreditCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class DetailReceiptCreditCell: UITableViewCell {

    @IBOutlet weak var lblKey: UILabel!
    
    func show(pair: KeyValuePair){
        self.lblKey.text = (pair.key as String?)! + " " + (pair.value as String) as String?
    }
}
