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
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var lblBillLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBillHeight: NSLayoutConstraint!
    @IBOutlet weak var lblReceiptLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblReceiptHeight: NSLayoutConstraint!
    
    func show(receipt: Array<KeyValuePair>){
        self.lblBillHeight.constant = 0
        self.lblBillLabelHeight.constant = 0
        self.lblReceiptHeight.constant = 0
        self.lblReceiptLabelHeight.constant = 0
        self.receipt = receipt
        (Constants.iPad) ? self.viewDetail.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0) : nil
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
                if self.lblBill.text != "" {
                    self.lblBillHeight.constant = 14
                    self.lblBillLabelHeight.constant = 14
                }
            }
            if pair.key.lowercased.range(of:"recibo") != nil {
                self.lblReceipt.text = pair.value as String
                if self.lblReceipt.text != "" {
                    self.lblReceiptHeight.constant = 14
                    self.lblReceiptLabelHeight.constant = 14
                }
            }
            self.viewDetail.layoutIfNeeded()
        }
    }
    
}
