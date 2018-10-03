//
//  TransactionsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/27/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class TransactionsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    
    var transferTypes: Array<TransferType> = []
    var originAccounts: Array<Account> = []
    var fromAccounts: Array<Account> = []
    var originAccount: Account? = nil
    var fromAccount: Account? = nil
    var transferTypeSelected: TransferType? = nil
    var colorArray: Array<UIColor> = [UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0), UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0), UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMenu()
        self.title = "Transferencias"
        self.keyboardEvent()
        self.hideKeyboardWhenTappedAround()
        self.txtDescription.delegate = self
        self.setDesign()
        self.loadTransferTypes()
    }

    func setMenu(){
        self.navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(image: UIImage(named: "menuCustom"), landscapeImagePhone: UIImage(named: "menuCustom"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = view.frame.width * 0.80
        SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }
    
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(TransactionsViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TransactionsViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 60
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        self.view.frame.origin.y = -150
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setDesign(){
        self.viewBody.isHidden = true
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 40, 0, 40)
        self.txtAmount.layer.borderWidth = 0.7
        self.txtAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtAmount.layer.cornerRadius = 4
        self.txtAmount.leftViewMode = UITextFieldViewMode.always
        let labelFrame = CGRect(x: 0, y: 0, width: 20, height: 40)
        let label = UILabel(frame: labelFrame)
        label.font = self.txtAmount.font
        label.textColor = self.txtAmount.textColor
        self.txtAmount.leftView = label
        self.txtDescription.layer.borderWidth = 0.7
        self.txtDescription.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtDescription.layer.cornerRadius = 4
        self.btnTransfer.layer.cornerRadius = 3
        self.txtDescription.leftViewMode = UITextFieldViewMode.always
        self.txtDescription.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtDescription.frame.height))
        let border1 = CALayer()
        border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border1.frame = CGRect(x: 15, y: (self.viewHeader.frame.size.height) - 1, width: (UIScreen.main.bounds.width) - 30, height: 1)
        border1.borderWidth = 1
        self.viewHeader.layer.addSublayer(border1)
        self.disableButton(btn: self.btnTransfer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.transferTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TransferTypeCell", for: indexPath) as! OptionMenuSinpeCell
        let type = self.transferTypes[indexPath.row]
        cell.showTransferType(type: type, color: self.colorArray[type.color])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = self.transferTypes[indexPath.item]
        if !type.selected {
            for item in self.transferTypes {
                item.selected = false
            }
            type.selected = true
            self.transferTypeSelected = type
            self.title = self.transferTypeSelected?.name.description
            self.cleanScreen()
            self.loadAccountsByType()
        }
        self.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if (self.fromAccounts.count) < 1 {
                self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
                vc.products = self.fromAccounts//(self.fromAccounts.copy() as? Accounts)?.list as Array<Account>?
                vc.detailServiceViewController = self
                vc.productSelected = self.fromAccount
                vc.productType = "cuentaDestino"
                vc.sectionType = "transaccionDestino"
                self.show(vc, sender: nil)
            }
        }
        else{
            if (self.originAccounts.count) < 1 {
                self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
                vc.products = self.originAccounts//(self.fromAccounts.copy() as? Accounts)?.list as Array<Account>?
                vc.detailServiceViewController = self
                vc.productSelected = self.originAccount
                vc.productType = "cuentaOrigen"
                vc.sectionType = "transaccionOrigen"
                self.show(vc, sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AccountServiceCell", for: indexPath) as! AccountServiceCell
        if indexPath.row > 0{
            if self.fromAccount != nil {
                cell.show(accountDesc: "Cuenta IBAN", ibanNumber: (self.fromAccount?.iban.description)!,
                          accountTotal: 0,
                          selectAccount: (self.fromAccount?.aliasName as String?)!,
                          currencySign: "")
            }
            else{
                cell.show(accountDesc: "", ibanNumber: "", accountTotal: 0,
                          selectAccount: "Seleccione una cuenta", currencySign: "")
            }
        }
        else{
            if self.originAccount != nil {
                cell.show(accountDesc: "Cuenta IBAN", ibanNumber: (self.originAccount?.iban.description)!,
                          accountTotal: (self.originAccount?.availableBalance)!,
                          selectAccount: (self.originAccount?.aliasName as String?)!,
                          currencySign: (self.originAccount?.currencySign as String?)!,
                          customTitle: "Cuenta Origen")
            }
            else{
                cell.show(accountDesc: "", ibanNumber: "", accountTotal: 0,
                          selectAccount: "Seleccione una cuenta", currencySign: "", customTitle: "Cuenta Origen")
            }
        }
        if((cell.layer.sublayers?.count)! < 4) {
            let border1 = CALayer()
            border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border1.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 30, height: 1)
            border1.borderWidth = 1
            cell.layer.addSublayer(border1)
            cell.layer.masksToBounds = true
        }
        return cell
    }
    
    override func cleanProductSelect(type: String) {
        if type == "cuentaDestino"{
            self.fromAccount = nil
            (self.txtAmount.leftView as! UILabel).text =  ""
        }
        else{
            self.originAccount = nil
        }
        self.tableView.reloadData()
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        if type == "cuentaDestino"{
            self.fromAccount = product as? Account
            if self.txtAmount.text != "" {
                (self.txtAmount.leftView as! UILabel).text =  self.fromAccount?.currencySign == "COL" ?  "   ¢" : "   $"
            }
        }
        else{
            self.originAccount = product as? Account
        }
        self.tableView.reloadData()
        self.validForm()
    }

    @IBAction func changeAmount(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 11)
        let amountIn = self.txtAmount.text
        if amountIn != "" {
            (self.txtAmount.leftView as! UILabel).text =  (self.fromAccount == nil) ? "" : (self.fromAccount?.currencySign == "COL") ?  "   ¢" : "   $"
            let amount = Helper.removeFormatAmount(amountIn)
            self.txtAmount.text = Helper.formatAmountInt(Int(amount)! as NSNumber)
        }
        else{
            (self.txtAmount.leftView as! UILabel).text = ""
        }
        self.validForm()
    }
    
    @IBAction func changeDescription(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 100)
        self.validForm()
    }
    
    @IBAction func transfer(_ sender: UIButton) {
        self.showBusyIndicator("Loading Data")
        let request: TransferRequest = TransferRequest()
        request.aliasNameDestination = (self.fromAccount?.aliasName)!
        request.aliasNameOrigin = (self.originAccount?.aliasName)!
        request.nameAccountDestination = (self.fromAccount?.name)!
        request.nameAccountOrigin = (self.originAccount?.name)!
        request.reason = self.txtDescription.text! as NSString
        request.total = NSDecimalNumber(string: Helper.removeFormatAmount(self.txtAmount.text))
        request.typeTransfer = self.transferTypeSelected!.id
        ProxyManager.TransferConfirm(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                    self.prepareReceipt()
                }
                else {
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
    
    func cleanScreen(){
        self.lblFee.text = Helper.formatAmount(self.transferTypeSelected?.commission, currencySign: (self.transferTypeSelected?.currencySign.description)!)
        self.viewBody.isHidden = false
        self.fromAccount = nil
        self.originAccount = nil
        self.txtAmount.text = ""
        self.txtDescription.text = ""
        (self.txtAmount.leftView as! UILabel).text = ""
        self.tableView.reloadData()
        self.validForm()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnTransfer)
        if self.originAccount != nil && self.fromAccount != nil && self.txtAmount.text != "" && self.txtDescription.text != "" {
            self.enableButton(btn: self.btnTransfer)
        }
    }
    
    func loadTransferTypes(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.TransferTypes(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.transferTypes = (result.data?.list)!
                    self.collectionView.reloadData()
                    self.hideBusyIndicator()
                    if self.transferTypes.count < 1 {
                        self.showAlert("Atención", messageKey: "No existen tipos de transferencias")
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
    
    func loadAccountsByType(){
        self.showBusyIndicator("Loading Data")
        let request: TransferAccountsRequest = TransferAccountsRequest()
        request.transferTypeId = (self.transferTypeSelected?.id.description)!
        ProxyManager.AccountsByTransferType(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.fromAccounts = (result.data?.destinationAccounts)!
                    self.originAccounts = (result.data?.list)!
                    self.hideBusyIndicator()
                    if (self.fromAccounts.count) < 1 || (self.originAccounts.count) < 1 {
                        self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
                    }
                }
                else {
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
    
    func prepareReceipt(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptConfirmViewController") as! ReceiptConfirmViewController
        vc.logo = self.transferTypeSelected?.image
        vc.accountToUse = self.originAccount
        vc.fromAccount = self.fromAccount
        vc.mainViewController = self
        vc.confirmDesc = "Por favor confirmar los datos de la transferencia"
        vc.actionDesc = "Monto a Debitar"
        vc.titleScreen = (self.transferTypeSelected?.name.description)!
        vc.typeProduct = 4
        vc.desc = self.txtDescription.text!
        let totalString = Helper.removeFormatAmount(self.txtAmount.text)
        var totalInt = Int(totalString)
        let feeInt = Int(truncating: (self.transferTypeSelected?.commission)!)
        totalInt = totalInt! + feeInt
        vc.amount = (totalInt?.description)!
        vc.amountFinal = Helper.removeFormatAmount(self.txtAmount.text)
        vc.currencyToUse = (self.fromAccount?.currencySign.description)!
        vc.transferType = self.transferTypeSelected
        self.present(vc, animated: true)
    }
    
}
