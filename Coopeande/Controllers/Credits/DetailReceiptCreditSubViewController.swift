//
//  DetailReceiptCreditSubViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DetailReceiptCreditSubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAliasAccount: UILabel!
    @IBOutlet weak var lblTypeAccount: UILabel!
    @IBOutlet weak var lblCreditType: UILabel!
    @IBOutlet weak var lblCreditAlias: UILabel!
    @IBOutlet weak var lblCreditTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCreditAliasHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var viewTableHeight: NSLayoutConstraint!
    var receipt: ReceiptService? = nil
    var account: Account? = nil
    var type: String = ""
    var alias: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(service: ReceiptService, account: Account, type: String, alias: String, bill: Bool){
        self.receipt = service
        self.account = account
        self.type = type
        self.alias = alias
        if !bill {
            self.lblCreditTypeHeight.constant = 0
            self.lblCreditAliasHeight.constant = 0
            self.viewTableHeight.constant = 140
            self.lblCreditType.layoutIfNeeded()
            self.lblCreditAlias.layoutIfNeeded()
            self.viewTable.layoutIfNeeded()
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
        self.lblCreditType.text = self.type
        self.lblCreditAlias.text = self.alias
        self.lblName.text = self.account?.name as String?
        self.lblTypeAccount.text = self.account?.typeDescription as String?
        self.lblAliasAccount.text = self.account?.aliasName as String?
        self.lblAccountNumber.text = "Cuenta IBAN  " + (self.account?.iban.description)!
        if(self.receipt != nil) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailReceiptCreditCell", for: indexPath) as! DetailReceiptCreditCell
            cell.show(pair: (self.receipt?.detailList[indexPath.row])!)
            return cell
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
