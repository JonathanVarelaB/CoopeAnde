//
//  ReceiptCreditCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class ReceiptCreditCell: UITableViewCell {
    
    var receipt: Array<KeyValuePair>? = nil
    @IBOutlet weak var lblOperation: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblMoratorium: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCreditAmount: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    
    func show(receipt: Array<KeyValuePair>){
        self.receipt = receipt
        (Constants.iPad) ? self.viewDetails.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0) : nil
        for pair in self.receipt! {
            if pair.key.lowercased.range(of:"operaci") != nil {
                self.lblOperation.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"deudor") != nil {
                self.lblOwner.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"principal") != nil {
                self.lblMain.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"inter") != nil {
                self.lblInterest.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"moratorio") != nil {
                self.lblMoratorium.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"otros") != nil {
                self.lblOthers.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"monto") != nil {
                self.lblAmount.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"fecha") != nil {
                self.lblDate.text = pair.value as String
            }
            if pair.key.lowercased.range(of:"saldo") != nil {
                self.lblCreditAmount.text = pair.value as String
            }
        }
    }
    
}
