//
//  SinpeTransactionsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SinpeTransactionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDesc.delegate = self
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
        self.view.frame.origin.y = -150
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
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
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectContactViewController") as! SelectContactViewController
        vc.controller = self
        vc.sectionType = "seleccionarContactoTrans"
        vc.titleScreen = "Contactos"
        self.show(vc, sender: nil)
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
                vc.sectionType = "sinpeTransaction"
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
        ProxyManager.GetAccountsOrigin(success: {
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
            self.lblAmount.text = Helper.formatAmountInt(Int(amount)! as NSNumber)
        }
        else{
            (self.lblAmount.leftView as! UILabel).text = ""
        }
        self.validForm()
    }
    
    @IBAction func changeDescription(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 30)
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
                    self.prepareReceipt()
                    self.hideBusyIndicator()
                }
                else {
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
