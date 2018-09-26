//
//  DetailReceiptServiceCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class DetailReceiptServiceCell: UITableViewCell {
    
    @IBOutlet weak var lblKey: UILabel!
    
    func show(pair: KeyValuePair){
        /*let key = pair.key.lowercased as String
        if key.range(of:"monto") != nil {
            self.lblKey.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            self.lblValue.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            self.lblValue.textColor = UIColor(red:0.00, green:0.44, blue:0.61, alpha:1.0)
        }*/
        //self.lblKey.text = (pair.key as String?)
        //self.lblValue.text = pair.value as String?
        self.lblKey.text = (pair.key as String?)! + " " + (pair.value as String) as String?
    }
    
}
