//
//  PayCreditDetailViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class PayCreditDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgCredit: UIImageView!
    @IBOutlet weak var lblCreditType: UILabel!
    @IBOutlet weak var lblCreditAlias: UILabel!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var btnPay: UIButton!
    
    var logo: UIImage? = nil
    var titleCredit: String = ""
    var idProduct: String = ""
    var payCreditTypes: PayCreditTypes? = nil
    var fromAccounts: Accounts? = nil
    var payCreditType: PayCreditType? = nil
    var accountToUse: Account? = nil
    var showCompleteInfo: Bool = false
    var selectedReceiptCredit: Array<KeyValuePair>? = nil
    var dataResponseReceiptCredit: ReceiptService? = nil
    var aliasProduct: String = ""
    var creditType: String = ""
    var operation: String = ""
    var mainViewController: CreditDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCreditType.text = self.titleCredit
        self.imgCredit.image = self.logo
        self.lblCreditAlias.text = self.aliasProduct
        self.disableButton(btn: self.btnPay)
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.btnPay.layer.cornerRadius = 3
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border.borderWidth = 1
        self.optionsTable.layer.addSublayer(border)
        self.optionsTable.layer.masksToBounds = true
        self.title = "Pago de Crédito"
        self.loadPayCreditType(idProduct: self.idProduct)
        if self.payCreditTypes != nil && self.payCreditTypes?.count == 1 {
            self.assignProductSelect(product: (self.payCreditTypes?.list[0])!, type: "tipoRecibo")
            self.payCreditTypes?.list[0].selected = true
        }
        if self.fromAccounts != nil && self.fromAccounts?.count == 1 {
            self.assignProductSelect(product: (self.fromAccounts?.list[0])!, type: "cuenta")
            self.fromAccounts?.list[0].selected = true
        }
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.backAction()
    }
    
    func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                if self.payCreditTypes != nil {
                    if (self.payCreditTypes?.list.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen tipos de recibo")
                    }
                    else{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
                        vc.products = (self.payCreditTypes?.copy() as? PayCreditTypes)?.list
                        vc.detailServiceViewController = self
                        vc.productSelected = self.payCreditType
                        vc.productType = "tipoRecibo"
                        vc.sectionType = "creditos"
                        self.show(vc, sender: nil)
                    }
                }
                else{
                    self.showAlert("Atención", messageKey: "Ocurrió un error intente de nuevo")
                }
                break
            case 1:
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
                        vc.sectionType = "creditos"
                        self.show(vc, sender: nil)
                    }
                }
                else{
                    self.showAlert("Atención", messageKey: "Ocurrió un error intente de nuevo")
                }
            default:
                print(indexPath.row)
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.showCompleteInfo) ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 2 && self.selectedReceiptCredit != nil{
            return 200.0
        }
        return 80.0
    }
    
    func identifyCell(indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row{
        case 0:
            let cell = self.optionsTable.dequeueReusableCell(withIdentifier: "InfoServiceCell", for: indexPath) as! InfoServiceCell
            if self.payCreditType != nil {
                cell.show(type: "Tipo de Recibo", select: "", firstDetail: "", secondDetail: (self.payCreditType?.name as String?)!, thirdDetail: "")
            }
            else{
                cell.show(type: "Tipo de Recibo", select: "Seleccione el tipo", firstDetail: "", secondDetail: "", thirdDetail: "")
            }
            return cell
        case 1:
            let cell = self.optionsTable.dequeueReusableCell(withIdentifier: "AccountServiceCell", for: indexPath) as! AccountServiceCell
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
        default:
            let cell = self.optionsTable.dequeueReusableCell(withIdentifier: "ReceiptCreditCell", for: indexPath) as! ReceiptCreditCell
            if self.selectedReceiptCredit != nil {
                cell.show(receipt: self.selectedReceiptCredit!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.identifyCell(indexPath: indexPath)
        if((cell.layer.sublayers?.count)! < 4) {
            if indexPath.row < 2 {
                let border = CALayer()
                border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
                border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 30, height: 1)
                border.borderWidth = 1
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
            }
        }
        return cell
    }
    
    override func cleanProductSelect(type: String) {
        if type != "cuenta"{
            //tipo de recibo
            self.payCreditType = nil
            self.showCompleteInfo = false
            self.selectedReceiptCredit = nil
        }
        self.accountToUse = nil
        self.optionsTable.reloadData()
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        if type == "cuenta"{
            self.accountToUse = product as? Account
            self.optionsTable.reloadData()
        }
        else{ //tipo de recibo
            self.payCreditType = product as? PayCreditType
            self.showBusyIndicator("")
            self.showCompleteInfo = false
            self.selectedReceiptCredit = nil
            self.optionsTable.reloadData()
            self.loadInfoReceiptCredit()
        }
        self.validForm()
    }
    
    func loadPayCreditType(idProduct: String){
        self.showBusyIndicator("Loading Data")
        let request: PayCreditTypeRequest = PayCreditTypeRequest()
        request.operation = idProduct as NSString
        ProxyManager.GetPayCreditType(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.payCreditTypes = result.data!
                    if (self.payCreditTypes?.list.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen tipos de recibo")
                    }
                    self.loadAccounts()
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
    
    func loadAccounts(){
        ProxyManager.AllBalances ({
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
    
    func loadInfoReceiptCredit(){
        let request: PayCreditConfirmRequest = PayCreditConfirmRequest()
        request.operationId = self.idProduct
        request.receiveTypeId = (self.payCreditType?.id)!
        ProxyManager.GetPayCreditConfirm(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dataResponseReceiptCredit = result.data
                    if((self.dataResponseReceiptCredit?.detailList.count)! > 0){
                        self.selectedReceiptCredit = self.dataResponseReceiptCredit!.detailList;
                        self.showCompleteInfo = true
                        self.optionsTable.reloadData()
                        self.hideBusyIndicator()
                    }
                    else{
                        self.selectedReceiptCredit = nil
                        self.hideBusyIndicator()
                        self.showAlert("Atención", messageKey: "No se poseen cuotas pendientes")
                    }
                }
                else {
                    self.selectedReceiptCredit = nil
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            self.selectedReceiptCredit = nil
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
    @IBAction func payCredit(_ sender: UIButton) {
        self.prepareReceipt()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnPay)
        if self.payCreditType != nil {
            if self.accountToUse != nil {
                self.enableButton(btn: self.btnPay)
            }
        }
    }
    
    func prepareReceipt(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptConfirmViewController") as! ReceiptConfirmViewController
        vc.logo = self.imgCredit.image
        vc.accountToUse = self.accountToUse
        vc.mainViewController = self.mainViewController
        vc.confirmDesc = "Por favor confirmar los datos del pago de cuota"
        vc.actionDesc = "Monto a Debitar"
        vc.creditAlias = self.aliasProduct
        vc.creditType = self.creditType
        vc.titleScreen = self.titleCredit
        vc.serviceToPay = self.dataResponseReceiptCredit
        vc.productSelect = self.payCreditType
        vc.operation = self.operation
        vc.amount = (self.dataResponseReceiptCredit?.total)!
        vc.typeProduct = 2
        self.present(vc, animated: true)
    }
    
}
