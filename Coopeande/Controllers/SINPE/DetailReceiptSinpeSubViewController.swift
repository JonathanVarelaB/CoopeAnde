//
//  DetailReceiptSinpeSubViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DetailReceiptSinpeSubViewController: UIViewController {

    @IBOutlet weak var lblVoucher: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblAccountAlias: UILabel!
    @IBOutlet weak var lblIban: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblReceiver: UILabel!
    @IBOutlet weak var lblVoucherHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDateHeight: NSLayoutConstraint!
    
    var bill: Bool = false
    
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(account: Account, description: String, contact: Contact, bill: Bool, voucher: String = "", date: String = ""){
        self.lblVoucher.text = "Comprobante: " + voucher
        self.lblDesc.text = description
        self.lblDate.text = date
        self.account = account
        self.lblPhoneNumber.text = "Teléfono Destino: " + contact.phoneNumber
        self.lblReceiver.text = contact.name
        self.lblOwner.text = self.account?.name as String?
        self.lblAccountType.text = self.account?.typeDescription as String?
        self.lblAccountAlias.text = self.account?.aliasName as String?
        self.lblIban.text = "Cuenta IBAN " + (self.account?.iban as String?)!
        if !bill {
            self.lblVoucherHeight.constant = 0
            self.lblDateHeight.constant = 0
            self.lblVoucher.layoutIfNeeded()
            self.lblDate.layoutIfNeeded()
            self.lblDescription.font = UIFont.boldSystemFont(ofSize: 11)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
