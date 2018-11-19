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
    @IBOutlet weak var lblCharge: UILabel!
    @IBOutlet weak var lblChargeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblChargeLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSinpeCharge: UILabel!
    @IBOutlet weak var lblSinpeChargeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSinpeChargeLabelHeight: NSLayoutConstraint!
    
    var bill: Bool = false
    
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(account: Account, description: String, contact: Contact, bill: Bool, charge: String, sinpeCharge: String, voucher: String = "", date: String = ""){
        self.lblVoucher.text = (voucher == "") ? "" : "Comprobante: " + voucher
        self.lblDesc.text = description
        self.lblDate.text = date
        self.account = account
        self.lblPhoneNumber.text = "Teléfono Destino: " + contact.phoneNumber
        self.lblReceiver.text = contact.name
        self.lblOwner.text = self.account?.name as String?
        self.lblAccountType.text = self.account?.typeDescription as String?
        self.lblAccountAlias.text = self.account?.aliasName as String?
        self.lblIban.text = "Cuenta IBAN " + (self.account?.iban as String?)!
        self.lblCharge.text = charge
        self.lblSinpeCharge.text = sinpeCharge
        if charge.isEmpty {
            self.lblChargeHeight.constant = 0
            self.lblChargeLabelHeight.constant = 0
        }
        if sinpeCharge.isEmpty {
            self.lblSinpeChargeHeight.constant = 0
            self.lblSinpeChargeLabelHeight.constant = 0
        }
        if !bill {
            self.lblVoucherHeight.constant = 0
            self.lblDateHeight.constant = 0
            //self.lblVoucher.layoutIfNeeded()
            //self.lblDate.layoutIfNeeded()
            //self.lblDescription.font = UIFont.boldSystemFont(ofSize: 11)
        }
        else{
            self.lblDescription.font = UIFont.systemFont(ofSize: 11)
        }
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
