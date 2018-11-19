//
//  AffiliationViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import ContactsUI

class AffiliationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var btnAffiliation: UIButton!
    
    var fromAccounts: Accounts? = nil
    var accountToUse: Account? = nil
    var contactToUse: Contact? = nil
    var borderHeader: CALayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardEvent()
        self.lblPhoneNumber.delegate = self
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
        if Constants.iPhone {
            self.view.frame.origin.y = -100
        }
        else if UIApplication.shared.statusBarOrientation.isLandscape{
            self.view.frame.origin.y = -60
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
        self.addBorderHeader()
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
    
    @objc func choosePhoneNumber() {
        self.view.endEditing(true)
        self.showAlertPhoneNumber(controller: self, section: "sinpeAfiliacion")
    }
    
    override func openFavorites() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectFavoriteNumberViewController") as! SelectFavoriteNumberViewController
        vc.viewController = self
        vc.favoriteSelected = self.contactToUse
        vc.sectionType = "sinpeAfiliacion"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.show(vc, sender: nil)
        }
    }
    
    override func openContacts() {
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0", argumentArray: nil)
        controller.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'", argumentArray: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty){
        if let phone: CNPhoneNumber = contactProperty.value as? CNPhoneNumber {
            self.lblPhoneNumber.text = phone.stringValue
            self.validPhoneFormat()
        }
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
                self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
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
    
    func afiliateSuccess(message: String){
        //self.showAlert("Afiliación Exitosa", messageKey: "Usted ha sido matriculado al SINPE Móvil exitosamente, con el número de teléfono " + self.lblPhoneNumber.text! + ".")
        self.showAlert("Afiliación Exitosa", messageKey: message)
        self.lblPhoneNumber.text = ""
        self.contactToUse = nil
        self.accountToUse = nil
        self.tableView.reloadData()
        self.validForm()
    }
    
}
