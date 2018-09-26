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
        self.loadAccounts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = self.accountsAfilliate[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditMovementsViewController") as! CreditMovementsViewController
        vc.actualAmount = account.iban.description
        vc.subTitle = "Cuenta Afiliada"
        vc.alias = "Teléfono: " + Helper.formatPhone(text: account.phoneNumber.description)
        vc.owner = account.name.description
        vc.currency = account.currencySign.description
        vc.walletId = account.walletId.description
        vc.iban = "Cuenta IBAN"
        vc.sectionType = 1
        self.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountsAfilliate.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AffiliatePhoneCell", for: indexPath) as! AffiliatePhoneCell
        cell.set(account: self.accountsAfilliate[indexPath.row])
        if((cell.layer.sublayers?.count)! < 4) {
            let border = CALayer()
            border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 30, height: 1)
            border.borderWidth = 1
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true
        }
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
                        self.showAlert("Atención", messageKey: "No existen cuentas afiliadas")
                    }
                }
                else{
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
}
