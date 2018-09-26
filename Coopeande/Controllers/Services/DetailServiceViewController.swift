//
//  DetailServiceViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class DetailServiceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var btnPay: UIButton!
    var logo: UIImage? = nil
    var titleService: String = ""
    var idProduct: String = ""
    var paymentServices: PaymentServices? = nil
    var payCreditTypes: PayCreditTypes? = nil
    var fromAccounts: Accounts? = nil
    var serviceToPay: PaymentService? = nil
    var accountToUse: Account? = nil
    var showCompleteInfo: Bool = false
    var dataResponseReceipt: ReceiptServices? = nil
    var selectedReceipt: ReceiptService? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblService.text = self.titleService
        self.imgService.image = self.logo
        self.disableButton(btn: self.btnPay)
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.btnPay.layer.cornerRadius = 3
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border.borderWidth = 1
        self.optionsTableView.layer.addSublayer(border)
        self.optionsTableView.layer.masksToBounds = true
        self.title = "Pago de Servicios"
        self.loadPaymentServices(idProduct: self.idProduct)
        if self.paymentServices != nil && self.paymentServices?.count == 1 {
            self.assignProductSelect(product: (self.paymentServices?.list[0])!, type: "servicio")
            self.paymentServices?.list[0].selected = true
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
        if(tableView == self.optionsTableView){
            switch indexPath.row {
            case 0:
                if self.paymentServices != nil {
                    if (self.paymentServices?.list.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen servicios")
                    }
                    else{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectServiceViewController") as! SelectServiceViewController
                        vc.services = self.paymentServices?.copy() as? PaymentServices
                        vc.detailServiceViewController = self
                        vc.serviceSelected = self.serviceToPay
                        self.show(vc, sender: nil)
                    }
                }
                else{
                    self.showAlert("Atención", messageKey: "Ocurrió un error intente de nuevo")
                }
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
                        vc.sectionType = "servicios"
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.optionsTableView){
            return (self.showCompleteInfo) ? 3 : 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(tableView == self.optionsTableView){
            if indexPath.row == 2 && self.selectedReceipt != nil {
                    return (CGFloat(70 + ((self.selectedReceipt?.detailList.count)! * 14)))
            }
            return 80.0
        }
        return 0
    }
    
    func identifyCell(indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row{
        case 0:
            let cell = self.optionsTableView.dequeueReusableCell(withIdentifier: "InfoServiceCell", for: indexPath) as! InfoServiceCell
            if self.serviceToPay != nil {
                cell.show(type: "Servicio", select: "", firstDetail: "", secondDetail: (self.serviceToPay?.aliasServiceName as String?)!, thirdDetail: "")
            }
            else{
                cell.show(type: "Servicio", select: "Seleccione el servicio", firstDetail: "", secondDetail: "", thirdDetail: "")
            }
            return cell
        case 1:
            let cell = self.optionsTableView.dequeueReusableCell(withIdentifier: "AccountServiceCell", for: indexPath) as! AccountServiceCell
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
            let cell = self.optionsTableView.dequeueReusableCell(withIdentifier: "ReceiptServiceCell", for: indexPath) as! ReceiptServiceCell
            if self.selectedReceipt != nil {
                cell.show(receipt: (self.selectedReceipt?.detailList)!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.optionsTableView){
            let cell = self.identifyCell(indexPath: indexPath)
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
        return UITableViewCell()
    }
    
    override func cleanProductSelect(type: String) {
        if type == "servicio"{
            self.serviceToPay = nil
            self.showCompleteInfo = false
            self.selectedReceipt = nil
        }
        self.accountToUse = nil
        self.optionsTableView.reloadData()
        self.validForm()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        if type == "servicio"{
            self.serviceToPay = product as? PaymentService
            self.showBusyIndicator("")
            self.showCompleteInfo = false
            self.selectedReceipt = nil
            self.optionsTableView.reloadData()
            self.loadInfoReceiptService()
        }
        else{
            if type == "cuenta"{
                self.accountToUse = product as? Account
                self.optionsTableView.reloadData()
            }
        }
        self.validForm()
    }
    
    func loadPaymentServices(idProduct: String){
        self.showBusyIndicator("Loading Data")
        let request: PaymentServicesRequest = PaymentServicesRequest()
        request.aliasTypeId = idProduct as NSString
        ProxyManager.GetAllByTypeId(request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.paymentServices = result.data!
                    if (self.paymentServices?.list.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen servicios")
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
    
    func loadInfoReceiptService(){
        let request : ReceiptDetailServiceRequest = ReceiptDetailServiceRequest()
        request.aliasServiceName = self.serviceToPay?.aliasServiceName
        request.aliasTypeId = self.serviceToPay?.aliasTypeId
        ProxyManager.GetReceiptDetailByService(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dataResponseReceipt = result.data
                    if((self.dataResponseReceipt?.count.intValue)! > 0){
                        self.selectedReceipt = self.dataResponseReceipt!.list[0];
                        self.showCompleteInfo = true
                        self.optionsTableView.reloadData()
                        self.hideBusyIndicator()
                    }
                    else{
                        self.selectedReceipt = nil
                        self.hideBusyIndicator()
                        self.showAlert("Atención", messageKey: "No se poseen recibos pendientes")
                    }
                }
                else {
                    self.selectedReceipt = nil
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            self.selectedReceipt = nil
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
    @IBAction func payService(_ sender: UIButton) {
        self.prepareReceipt()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnPay)
        if self.serviceToPay != nil {
            if self.accountToUse != nil {
                self.enableButton(btn: self.btnPay)
            }
        }
    }
    
    func prepareReceipt(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptConfirmViewController") as! ReceiptConfirmViewController
        vc.logo = self.imgService.image
        vc.accountToUse = self.accountToUse
        vc.mainViewController = self
        vc.titleReceipt = "Detalle del Recibo"
        vc.confirmDesc = "Por favor confirmar los datos del pago"
        vc.actionDesc = "Monto Pendiente"
        vc.titleScreen = self.lblService.text!
        vc.serviceToPay = self.selectedReceipt
        vc.productSelect = self.serviceToPay
        vc.amount = (self.selectedReceipt?.total)!
        vc.typeProduct = 1
        self.present(vc, animated: true)
    }
    
}
