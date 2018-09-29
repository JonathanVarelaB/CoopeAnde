//
//  DetailReceiptTransferSubViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/28/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DetailReceiptTransferSubViewController: UIViewController {

    @IBOutlet weak var lblVoucher: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOriginType: UILabel!
    @IBOutlet weak var lblOriginAlias: UILabel!
    @IBOutlet weak var lblOriginIban: UILabel!
    @IBOutlet weak var lblOriginOwner: UILabel!
    @IBOutlet weak var lblFromType: UILabel!
    @IBOutlet weak var lblFromAlias: UILabel!
    @IBOutlet weak var lblFromIban: UILabel!
    @IBOutlet weak var lblFromOwner: UILabel!
    @IBOutlet weak var viewVoucher: UIView!
    @IBOutlet weak var viewVoucherHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var viewAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFee: UIView!
    @IBOutlet weak var viewFeeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDateHeight: NSLayoutConstraint!
    
    var bill: Bool = false
    var transferType: String = ""
    var fromAccount: Account? = nil
    var originAccount: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(fromAccount: Account, originAccount: Account, description: String, amountFinal: String, transferType: TransferType, bill: Bool, voucher: String = "", date: String = ""){
        self.lblVoucher.text = voucher
        if let amo = Int(amountFinal) {
            self.lblAmount.text = Helper.formatAmount(NSNumber(value: amo), currencySign: fromAccount.currencySign.description)
        }
        self.lblFee.text = Helper.formatAmount(transferType.commission, currencySign: transferType.currencySign.description)
        self.lblDescription.text = description
        self.lblDate.text = date
        self.lblOriginType.text = originAccount.typeDescription.description
        self.lblOriginAlias.text = originAccount.aliasName.description
        self.lblOriginIban.text = "Cuenta IBAN " + originAccount.iban.description
        self.lblOriginOwner.text = originAccount.name.description
        self.lblFromType.text = fromAccount.typeDescription.description
        self.lblFromAlias.text = fromAccount.aliasName.description
        self.lblFromIban.text = "Cuenta IBAN " + fromAccount.iban.description
        self.lblFromOwner.text = fromAccount.name.description
        if !bill {
            self.viewVoucherHeight.constant = 0
            self.viewVoucher.layoutIfNeeded()
            self.lblDateHeight.constant = 0
            self.lblDate.layoutIfNeeded()
        }
        if transferType.id.description.range(of:"1") != nil{ // Entre cuentasr
            self.viewAmountHeight.constant = 0
            self.viewAmount.layoutIfNeeded()
            self.viewFeeHeight.constant = 0
            self.viewFee.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
