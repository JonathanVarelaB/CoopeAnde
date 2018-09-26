//
//  AffiliationViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AffiliationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var btnAffiliation: UIButton!
    
    var fromAccounts: Accounts? = nil
    var accountToUse: Account? = nil
    var contactToUse: Contact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardEvent()
        self.setDesign()
        self.loadAccounts()
    }

    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(AffiliationViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AffiliationViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        self.view.frame.origin.y = -100
    }
    
    func setDesign(){
        self.lblPhoneNumber.layer.borderWidth = 0.7
        self.lblPhoneNumber.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.lblPhoneNumber.layer.cornerRadius = 4
        self.btnAffiliation.layer.cornerRadius = 3
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AffiliationViewController.choosePhoneNumber))
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus3")
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 21)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        self.lblPhoneNumber.rightView = imageView
        self.lblPhoneNumber.rightViewMode = UITextFieldViewMode.always
        self.lblPhoneNumber.leftViewMode = UITextFieldViewMode.always
        self.lblPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.lblPhoneNumber.frame.height))
        self.disableButton(btn: self.btnAffiliation)
    }
    
    @objc func choosePhoneNumber() {
        self.showAlertPhoneNumber(controller: self, section: "sinpeAfiliacion")
    }
    
    override func openFavorites() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectFavoriteNumberViewController") as! SelectFavoriteNumberViewController
        vc.viewController = self
        vc.favoriteSelected = self.contactToUse
        vc.sectionType = "sinpeAfiliacion"
        self.show(vc, sender: nil)
    }
    
    override func openContacts() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectContactViewController") as! SelectContactViewController
        vc.controller = self
        vc.sectionType = "seleccionarContactoAfil"
        vc.titleScreen = "Contactos"
        self.show(vc, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAffiliation(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SinpeConfirmViewController") as! SinpeConfirmViewController
        vc.accountToUse = self.accountToUse
        vc.confirmation = "¿Desea afiliar la cuenta y el número de teléfono seleccionado?"
        vc.phoneNumber = self.lblPhoneNumber.text!
        vc.titleConfirm = "Confirmar Afiliación"
        vc.titleScreen = "Afiliación de SINPE Móvil"
        vc.operationType = "afiliar"
        vc.afiliateController = self
        self.present(vc, animated: true)
    }
    
    @IBAction func changePhoneNumber(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 9)
        self.validPhoneFormat()
    }
    
    func validPhoneFormat(){
        self.lblPhoneNumber.text = Helper.formatPhone(text: lblPhoneNumber.text!)
        self.validForm()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.fromAccounts != nil {
            if (self.fromAccounts?.list.count)! < 1 {
                self.showAlert("Atención", messageKey: "No existen cuentas")
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
                vc.products = (self.fromAccounts?.copy() as? Accounts)?.list as Array<Account>?
                vc.detailServiceViewController = self
                vc.productSelected = self.accountToUse
                vc.productType = "cuenta"
                vc.sectionType = "sinpeAfiliacion"
                self.show(vc, sender: nil)
            }
        }
        else{
            self.showAlert("Atención", messageKey: "Ocurrió un error intente de nuevo")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AccountServiceCell", for: indexPath) as! AccountServiceCell
        if self.accountToUse != nil {
            cell.show(accountDesc: "Cuenta IBAN", ibanNumber: (self.accountToUse?.iban as String?)!,
                      accountTotal: (self.accountToUse?.availableBalance)!,
                      selectAccount: (self.accountToUse?.aliasName as String?)!,
                      currencySign: (self.accountToUse?.currencySign as String?)!)
        }
        else{
            cell.show(accountDesc: "", ibanNumber: "", accountTotal: 0,
                      selectAccount: "Seleccione la cuenta", currencySign: "")
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
    
    func loadAccounts(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetAccountToAfiliate({
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.fromAccounts = result.data
                    self.hideBusyIndicator()
                    if (self.fromAccounts?.list.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen cuentas")
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
    
    override func cleanProductSelect(type: String) {
        if type == "cuenta"{
            self.accountToUse = nil
            self.tableView.reloadData()
        }
        else{
            self.contactToUse = nil
            self.lblPhoneNumber.text = ""
        }
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        if type == "cuenta"{
            self.accountToUse = product as? Account
            self.tableView.reloadData()
        }
        else{
            self.contactToUse = (product as? Contact)
            self.lblPhoneNumber.text = self.contactToUse?.phoneNumber
            self.validPhoneFormat()
        }
        self.validForm()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnAffiliation)
        if (self.lblPhoneNumber.text?.count)! > 8 && self.accountToUse != nil {
            self.enableButton(btn: self.btnAffiliation)
        }
    }
    
    func afiliateSuccess(){
        self.showAlert("Afiliación Exitosa", messageKey: "Usted ha sido matriculado al SINPE Móvil exitosamente, con el número de teléfono " + self.lblPhoneNumber.text! + ".")
        self.lblPhoneNumber.text = ""
        self.contactToUse = nil
        self.accountToUse = nil
        self.tableView.reloadData()
        self.validForm()
    }
    
}
