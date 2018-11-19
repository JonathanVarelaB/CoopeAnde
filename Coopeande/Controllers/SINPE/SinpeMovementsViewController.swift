//
//  SinpeMovementsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SinpeMovementsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var accountsAfilliate: Array<Account> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 80
        self.tableView.estimatedRowHeight = 80
        self.loadAccounts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = self.accountsAfilliate[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditMovementsViewController") as! CreditMovementsViewController
        //vc.actualAmount = account.iban.description
        vc.subTitle = "Cuenta Afiliada"
        //vc.alias = "Teléfono: " + Helper.formatPhone(text: account.phoneNumber.description)
        //vc.owner = account.name.description
        vc.currency = account.currencySign.description
        vc.walletId = account.walletId.description
        //vc.iban = "Cuenta IBAN"
        vc.sectionType = 1
        
        vc.iban = account.typeDescription.description
        vc.type = account.aliasName.description
        vc.alias = account.iban != "" ? "Cuenta IBAN " + account.iban.description : ""
        vc.owner = "Teléfono: " + Helper.formatPhone(text: account.phoneNumber.description)
        vc.operation = account.name.description
        
        self.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountsAfilliate.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AffiliatePhoneCell", for: indexPath) as! AffiliatePhoneCell
        cell.set(account: self.accountsAfilliate[indexPath.row])
        return cell
    }
    
    func loadAccounts(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetAllWalletAccountsAfilliate(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.accountsAfilliate = (result.data?.list)!
                    self.tableView.reloadData()
                    self.hideBusyIndicator()
                    if self.accountsAfilliate.count < 1 {
                        self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
                    }
                }
                else{
                    self.hideBusyIndicator()
                    if(!self.sessionTimeOutException(result.code.description, message: result.message.description)){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
}
