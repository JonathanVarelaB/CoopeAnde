//
//  ReceiptServiceCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ReceiptServiceCell: UITableViewCell{
    
    var receipt: Array<KeyValuePair>? = nil
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblQuota: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBill: UILabel!
    @IBOutlet weak var lblReceipt: UILabel!
    
    func show(receipt: Array<KeyValuePair>){
        self.receipt = receipt
        for pair in self.receipt! {
            if pair.key.lowercased.range(of:"monto") != nil {
                self.lblAmount.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"cuota") != nil {
                self.lblQuota.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"fecha") != nil {
                self.lblDate.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"factura") != nil {
                self.lblBill.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"recibo") != nil {
                self.lblReceipt.text = pair.value as String
            }
        }
    }
    
}
