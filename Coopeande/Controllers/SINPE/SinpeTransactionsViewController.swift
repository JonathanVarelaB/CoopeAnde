//
//  SinpeTransactionsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import ContactsUI

class SinpeTransactionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var lblAmount: UITextField!
    @IBOutlet weak var lblDesc: UITextField!
    @IBOutlet weak var btnTransaction: UIButton!
    
    var fromAccounts: Accounts? = nil
    var accountToUse: Account? = nil
    var contactName: String = ""
    var contactToUse: Contact? = nil
    var receiverPerson: String = ""
    var borderHeader: CALayer = CALayer()
    var charge: String = ""
    var sinpeCharge: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDesc.delegate = self
        self.lblAmount.delegate = self
        self.lblPhoneNumber.delegate = self
        self.keyboardEvent()
        self.setDesign()
        self.loadAccounts()
    }

    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(SinpeTransactionsViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SinpeTransactionsViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        if Constants.iPhone {
            self.view.frame.origin.y = -150
        }
        else if UIApplication.shared.statusBarOrientation.isLandscape{
            if self.lblPhoneNumber.isFirstResponder {
                self.view.frame.origin.y = -60
            }
            else if self.lblAmount.isFirstResponder {
                self.view.frame.origin.y = -130
            }
            else{
                self.view.frame.origin.y = -210
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lblPhoneNumber{
            self.lblAmount.becomeFirstResponder()
            if UIApplication.shared.statusBarOrientation.isLandscape{
                self.view.frame.origin.y = -130
            }
        }
        else{
            if textField == lblAmount{
                self.lblDesc.becomeFirstResponder()
                if UIApplication.shared.statusBarOrientation.isLandscape{
                    self.view.frame.origin.y = -210
                }
            }
            else{
                self.view.endEditing(true)
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setDesign(){
        self.lblPhoneNumber.layer.borderWidth = 0.7
        self.lblPhoneNumber.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.lblPhoneNumber.layer.cornerRadius = 4
        self.lblAmount.layer.borderWidth = 0.7
        self.lblAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.lblAmount.layer.cornerRadius = 4
        self.lblAmount.leftViewMode = UITextFieldViewMode.always
        let labelFrame = CGRect(x: 0, y: 0, width: 20, height: 40)
        let label = UILabel(frame: labelFrame)
        //label.text = "   ¢"
        label.font = self.lblAmount.font
        label.textColor = self.lblAmount.textColor
        self.lblAmount.leftView = label
        self.lblDesc.layer.borderWidth = 0.7
        self.lblDesc.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.lblDesc.layer.cornerRadius = 4
        self.btnTransaction.layer.cornerRadius = 3
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
        self.lblDesc.leftViewMode = UITextFieldViewMode.always
        self.lblDesc.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.lblPhoneNumber.frame.height))
        self.disableButton(btn: self.btnTransaction)
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
        self.showAlertPhoneNumber(controller: self, section: "sinpeTransaccion")
    }
    
    override func openFavorites() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectFavoriteNumberViewController") as! SelectFavoriteNumberViewController
        vc.viewController = self
        vc.favoriteSelected = self.contactToUse
        vc.sectionType = "sinpeTransaccion"
        self.show(vc, sender: nil)
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
                vc.sectionType = "sinpeTransaction"
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
        //ProxyManager.GetAllWalletAccountsAfilliate(success: {
        ProxyManager.GetAccountsOrigin(success: {
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
            self.contactName = ""
        }
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        if type == "cuenta"{
            self.accountToUse = product as? Account
            self.tableView.reloadData()
        }
        else{
            self.contactToUse = (product as! Contact)
            self.lblPhoneNumber.text = self.contactToUse?.phoneNumber
            self.contactName = (self.contactToUse?.name)!
            self.validPhoneFormat()
        }
        self.validForm()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnTransaction)
        if self.accountToUse != nil && (self.lblPhoneNumber.text?.count)! > 8  && self.lblAmount.text != "" && self.lblDesc.text != "" {
            self.enableButton(btn: self.btnTransaction)
        }
    }
    
    func validPhoneFormat(){
        self.lblPhoneNumber.text = Helper.formatPhone(text: lblPhoneNumber.text!)
        self.validForm()
    }
    
    @IBAction func changePhoneNumber(_ sender: UITextField) {
        self.contactName = ""
        self.maxLenght(textField: sender, maxLength: 9)
        self.validPhoneFormat()
    }
    
    @IBAction func changeAmount(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 11)
        let amountIn = self.lblAmount.text
        if amountIn != "" {
            (self.lblAmount.leftView as! UILabel).text = "   ¢"
            let amount = Helper.removeFormatAmount(amountIn)
            self.lblAmount.text = Helper.formatAmountInt(amount)
        }
        else{
            (self.lblAmount.leftView as! UILabel).text = ""
        }
        self.validForm()
    }
    
    @IBAction func changeDescription(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 100)
        self.validForm()
    }
    
    @IBAction func transaction(_ sender: UIButton) {
        self.showBusyIndicator("Loading Data")
        let request: WalletTransferRequest = WalletTransferRequest()
        request.aliasNameOrigin = (self.accountToUse?.aliasName)!
        request.destinationPhoneNumber = self.lblPhoneNumber.text!.replacingOccurrences(of: "-", with: "")
        request.nameAccountOrigin = (self.accountToUse?.name)!
        request.reason = self.lblDesc.text! as NSString
        request.total = Int(Helper.removeFormatAmount(self.lblAmount.text))!
        request.walletId = (self.accountToUse?.walletId)!
        ProxyManager.WalletTransferConfirm(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    if let name = result.data?.list.last?.value.description {
                        self.receiverPerson = name
                    }
                    self.charge = (result.data?.charge)!
                    self.sinpeCharge = (result.data?.sinpeCharge)!
                    self.prepareReceipt()
                    self.hideBusyIndicator()
                }
                else {
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
    
    func prepareReceipt(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptConfirmViewController") as! ReceiptConfirmViewController
        vc.logo = UIImage(named: "sinpeLogo")
        vc.accountToUse = self.accountToUse
        vc.contactToUse = Contact(name: self.receiverPerson, number: self.lblPhoneNumber.text!)
        vc.mainViewController = self
        vc.confirmDesc = "Por favor confirmar los datos de la transferencia"
        vc.actionDesc = "Monto Transferencia"
        vc.titleScreen = "Transferencia SINPE Móvil"
        vc.titleReceipt = "Confirmar Transferencia"
        vc.typeProduct = 3
        vc.desc = self.lblDesc.text!
        vc.amount = Helper.removeFormatAmount(self.lblAmount.text)
        vc.charge = self.charge
        vc.sinpeCharge = self.sinpeCharge
        self.present(vc, animated: true)
    }
    
    func transactionSuccess(){
        self.accountToUse = nil
        self.contactToUse = nil
        self.lblAmount.text = ""
        self.contactName = ""
        self.lblPhoneNumber.text = ""
        self.lblDesc.text = ""
        (self.lblAmount.leftView as! UILabel).text = ""
        self.tableView.reloadData()
        self.validForm()
    }
    
}
