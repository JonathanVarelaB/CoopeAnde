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
    var borderHeader: CALayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDisaffiliation.layer.cornerRadius = 3
        self.addBorderHeader()
        self.disableButton(btn: self.btnDisaffiliation)
        self.loadPhonesAffiliate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addBorderHeader(){
        self.borderHeader.removeFromSuperlayer()
        self.borderHeader = CALayer()
        self.borderHeader.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        self.borderHeader.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        self.borderHeader.borderWidth = 1
        self.tableView.layer.addSublayer(self.borderHeader)
        self.tableView.layer.masksToBounds = true
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.addBorderHeader()
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhoneAffiliateCell", for: indexPath) as! PhoneAffiliateCell
        if self.accountToUse != nil {
            cell.show(select: self.accountToUse.aliasName.description, phoneNumber: self.accountToUse.phoneNumber.description, name: self.accountToUse.name.description)
        }
        else{
            cell.show(select: "Seleccione el teléfono afiliado", phoneNumber: "", name: "")
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
        vc.confirmation = "¿Desea inactivar la cuenta seleccionada?"
        vc.phoneNumber = Helper.formatPhone(text: self.accountToUse.phoneNumber.description)
        vc.titleConfirm = "Confirmar Inactivación"
        vc.titleScreen = "Inactivación de SINPE Móvil"
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
    
    func validForm(){
        disableButton(btn: self.btnDisaffiliation)
        if self.accountToUse != nil {
           enableButton(btn: self.btnDisaffiliation)
        }
    }
    
    func disafiliateSuccess(message: String){
        self.showAlert("Inactivación Exitosa", messageKey: message)
        self.accountToUse = nil
        self.tableView.reloadData()
        self.loadPhonesAffiliate()
        self.validForm()
    }
    
}
