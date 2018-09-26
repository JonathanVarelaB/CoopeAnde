//
//  DetailReceiptServiceSubViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/3/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DetailReceiptServiceSubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTypeAccount: UILabel!
    @IBOutlet weak var lblAliasAccount: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewDetailReceipt: UIView!
    @IBOutlet weak var lblVoucher: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblVoucherHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDateHeight: NSLayoutConstraint!
    @IBOutlet weak var lblServiceTypeHeight: NSLayoutConstraint!
    var bill: Bool = false
    
    var receipt: ReceiptService? = nil
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func set(service: ReceiptService, account: Account, voucher: String, date: String, type: String, bill: Bool){
        self.receipt = service
        self.account = account
        self.lblVoucher.text = "Comprobante: " + voucher
        self.lblDate.text = date
        self.lblServiceType.text = "Servicio: " + type
        if !bill {
            self.lblVoucherHeight.constant = 0
            self.lblDateHeight.constant = 0
            self.lblServiceTypeHeight.constant = 0
            self.lblVoucher.layoutIfNeeded()
            self.lblDate.layoutIfNeeded()
            self.lblServiceType.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.receipt != nil) {
            return (self.receipt?.detailList.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let pair = (self.receipt?.detailList[indexPath.row])!
        if pair.key.lowercased.range(of: "monto") != nil {
            return 0
        }
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.lblName.text = self.account?.name as String?
        self.lblTypeAccount.text = self.account?.typeDescription as String?
        self.lblAliasAccount.text = self.account?.aliasName as String?
        self.lblAccountNumber.text = "Cuenta IBAN  " + (self.account?.iban as String?)!
        if(self.receipt != nil) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailReceiptServiceCell", for: indexPath) as! DetailReceiptServiceCell
            cell.show(pair: (self.receipt?.detailList[indexPath.row])!)
            return cell
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
