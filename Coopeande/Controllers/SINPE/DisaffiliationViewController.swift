//
//  DisaffiliationViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DisaffiliationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDisaffiliation: UIButton!
    
    var accountsAfilliate: Accounts! = nil
    var accountToUse: Account! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDisaffiliation.layer.cornerRadius = 3
        self.disableButton(btn: self.btnDisaffiliation)
        self.loadPhonesAffiliate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.accountsAfilliate != nil {
            if (self.accountsAfilliate?.list.count)! < 1 {
                self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
                vc.products = (self.accountsAfilliate?.copy() as? Accounts)?.list as Array<Account>?
                vc.detailServiceViewController = self
                vc.productSelected = self.accountToUse
                vc.productType = "cuenta"
                vc.sectionType = "sinpeDesafiliacion"
                self.show(vc, sender: nil)
            }
        }
        else{
            self.showAlert("Atención", messageKey: "Ocurrió un error, intente de nuevo")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhoneAffiliateCell", for: indexPath) as! PhoneAffiliateCell
        if self.accountToUse != nil {
            cell.show(select: "", phoneNumber: self.accountToUse.phoneNumber.description)
        }
        else{
            cell.show(select: "Seleccione el teléfono afiliado", phoneNumber: "")
        }
        if((cell.layer.sublayers?.count)! < 4) {
            let border = CALayer()
            border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border.frame = CGRect(x: 15, y: 0, width: (cell.frame.size.width) - 30, height: 1)
            border.borderWidth = 1
            let border1 = CALayer()
            border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border1.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 30, height: 1)
            border1.borderWidth = 1
            cell.layer.addSublayer(border)
            cell.layer.addSublayer(border1)
            cell.layer.masksToBounds = true
        }
        return cell
    }
    
    override func cleanProductSelect(type: String) {
        self.accountToUse = nil
        self.tableView.reloadData()
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        self.accountToUse = product as? Account
        self.tableView.reloadData()
        self.validForm()
    }
    
    @IBAction func disaffiliate(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SinpeConfirmViewController") as! SinpeConfirmViewController
        vc.accountToUse = self.accountToUse
        vc.confirmation = "¿Desea desafiliar la cuenta seleccionada?"
        vc.phoneNumber = Helper.formatPhone(text: self.accountToUse.phoneNumber.description)
        vc.titleConfirm = "Confirmar Desafiliación"
        vc.titleScreen = "Desafiliación de SINPE Móvil"
        vc.operationType = "desafiliar"
        vc.disafiliateController = self
        self.present(vc, animated: true)
    }
    
    func loadPhonesAffiliate(){
        self.accountsAfilliate = nil
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetAllWalletAccountsAfilliate(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.accountsAfilliate = result.data
                    self.tableView.reloadData()
                    self.hideBusyIndicator()
                    if self.accountsAfilliate.list.count < 1 {
                        self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
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
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func validForm(){
        disableButton(btn: self.btnDisaffiliation)
        if self.accountToUse != nil {
           enableButton(btn: self.btnDisaffiliation)
        }
    }
    
    func disafiliateSuccess(message: String){
        self.showAlert("Desafiliación Exitosa", messageKey: message)
        self.accountToUse = nil
        self.tableView.reloadData()
        self.loadPhonesAffiliate()
        self.validForm()
    }
    
}
