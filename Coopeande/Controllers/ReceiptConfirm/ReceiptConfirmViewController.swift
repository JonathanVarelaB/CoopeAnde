//
//  ReceiptConfirmViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ReceiptConfirmViewController: BaseViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var lblTitleReceipt: UILabel!
    @IBOutlet weak var lblConfirmDesc: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblActionDesc: UILabel!
    @IBOutlet weak var viewActionDesc: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewMainReceipt: UIView!
    @IBOutlet weak var lblCreditType: UILabel!
    @IBOutlet weak var lblCreditAlias: UILabel!
    @IBOutlet weak var viewMainReceiptHeight: NSLayoutConstraint!
    @IBOutlet weak var viewButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    
    var logo: UIImage? = nil
    var titleScreen: String = ""
    var creditType: String = ""
    var creditAlias: String = ""
    var titleReceipt: String = ""
    var confirmDesc: String = ""
    var actionDesc: String = ""
    var accountToUse: Account! = nil
    var contactToUse: Contact! = nil
    var serviceToPay: ReceiptService! = nil
    var productSelect: SelectableProduct! = nil
    var mainViewController: BaseViewController!
    var typeProduct: Int = 0 // 1 -> servicios // 2 -> creditos // 3 -> sinpe // 4 -> transferencias
    var operation: String = ""
    var desc: String = ""
    var amount: String = ""
    var voucher: String = ""
    // TRANSFER
    var fromAccount: Account! = nil
    var amountFinal: String = ""
    var transferType: TransferType! = nil
    var currencyToUse: String = ""
    var exchangeRate: String = ""
    var debitAmount: String = ""
    var charge: String = ""
    var sinpeCharge: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch (self.typeProduct) {
        case 1:
            if self.productSelect != nil {
                self.productSelect = self.productSelect as! PaymentService
            }
            break;
        case 2:
            if self.productSelect != nil {
                self.productSelect = self.productSelect as! PayCreditType
            }
            break;
        default:
            print("default")
            break;
        }
        self.imgLogo.image = self.logo
        self.lblCreditType.text = self.creditType
        self.lblCreditAlias.text = self.creditAlias
        self.lblTitleScreen.text = self.titleScreen
        self.lblTitleReceipt.text = self.titleReceipt
        self.lblConfirmDesc.text = self.confirmDesc
        self.lblActionDesc.text = self.actionDesc
        if let a = Int(self.amount) {
            if self.typeProduct == 4 {
                self.lblTotal.text = Helper.formatAmount(NSNumber(value: a), currencySign: (self.currencyToUse))
            }
            else{
                self.lblTotal.text = "¢" + Helper.formatAmount(a as NSNumber)
            }
        }
        else{
            self.lblTotal.text = self.amount
        }
        self.setDesign()
        self.addSubViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            DispatchQueue.main.async() {
                self.viewButtonHeight.constant = 60
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.viewButtonHeight.constant = UIApplication.shared.statusBarOrientation.isLandscape ? 60 : 225
            self.view.layoutIfNeeded()
        }
    }
    
    func setDesign(){
        self.viewActionDesc.layer.cornerRadius = 12.5
        self.btnAccept.layer.cornerRadius = 3
        self.btnCancel.layer.cornerRadius = 3
        self.viewBody.layer.cornerRadius = 10
        self.viewMainReceipt.layer.cornerRadius = 10
    }

    func addSubViewController(){
        if self.accountToUse != nil {
            switch self.typeProduct {
            case 1:
                if self.serviceToPay != nil {
                    self.viewMainReceiptHeight.constant = 126
                    self.viewMainReceipt.layoutIfNeeded()
                    let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptServiceSubViewController") as! DetailReceiptServiceSubViewController
                    addChildViewController(subViewController)
                    subViewController.view.frame = self.viewMainReceipt.bounds
                    subViewController.set(service: self.serviceToPay, account: self.accountToUse, voucher: "", date: "", type: "", bill: false)
                    self.viewMainReceipt.addSubview(subViewController.view)
                }
                break
            case 2:
                if self.serviceToPay != nil {
                    let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptCreditSubViewController") as! DetailReceiptCreditSubViewController
                    addChildViewController(subViewController)
                    subViewController.view.frame = self.viewMainReceipt.bounds
                    subViewController.set(service: self.serviceToPay, account: self.accountToUse, type: "", alias: "", bill: false)
                    self.viewMainReceipt.addSubview(subViewController.view)
                }
                break
            case 3:
                self.viewMainReceiptHeight.constant = (self.charge != "" || self.sinpeCharge != "") ? 140 : 126
                self.viewMainReceipt.layoutIfNeeded()
                let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptSinpeSubViewController") as! DetailReceiptSinpeSubViewController
                addChildViewController(subViewController)
                subViewController.view.frame = self.viewMainReceipt.bounds
                subViewController.set(account: self.accountToUse, description: self.desc, contact: self.contactToUse, bill: false, charge: self.charge, sinpeCharge: self.sinpeCharge)
                self.viewMainReceipt.addSubview(subViewController.view)
                break
            case 4:
                self.viewMainReceiptHeight.constant = (self.transferType.id.description.range(of:"1") != nil)
                    ? ((self.fromAccount.currencySign == self.accountToUse.currencySign) ? 154 : 182) // cuando es Entre Cuentas con cambio de moneda o no
                    : 182
                self.viewMainReceipt.layoutIfNeeded()
                let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptTransferSubViewController") as! DetailReceiptTransferSubViewController
                addChildViewController(subViewController)
                subViewController.view.frame = self.viewMainReceipt.bounds
                subViewController.set(fromAccount: self.fromAccount, originAccount: self.accountToUse, description: self.desc,
                                      amountFinal: self.amountFinal, transferType: self.transferType, bill: false, exchangeRate: self.exchangeRate, debitAmount: self.debitAmount)
                self.viewMainReceipt.addSubview(subViewController.view)
                break
            default:
                print("default")
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        switch (self.typeProduct) {
        case 1:
            self.applyPaymentServices()
            break;
        case 2:
            self.applyPaymentCredit()
            break
        case 3:
            self.applyTransferSinpe()
            break
        case 4:
            self.applyTransfer()
            break
        default:
            print("default")
            break;
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func applyPaymentServices(){
        self.showBusyIndicator("Loading Data")
        let request : PayServiceBillRequest = PayServiceBillRequest()
        request.aliasNameAccount = self.accountToUse.aliasName
        request.aliasServiceName = (self.productSelect as! PaymentService).aliasServiceName
        request.aliasTypeId = (self.productSelect as! PaymentService).aliasTypeId
        request.bill = self.serviceToPay.bill
        request.receipt = self.serviceToPay.receipt
        var amountSend = self.amount.replacingOccurrences(of: "$", with: "")
        amountSend = amountSend.replacingOccurrences(of: "¢", with: "")
        request.amount = Helper.removeFormatAmount(amountSend)
        ProxyManager.PayBill(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                    self.showBill(infoConfirm: self.serviceToPay, infoPay: result.data!)
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
    
    func applyPaymentCredit(){
        self.showBusyIndicator("Loading Data")
        let request: PayCreditRequest = PayCreditRequest()
        request.accountAlias = self.accountToUse.aliasName as String
        request.operationId = self.operation
        request.receiveTypeId = (self.productSelect as! PayCreditType).id
        ProxyManager.GetPayCreditApply(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                    self.showBill(infoConfirm: self.serviceToPay, infoPay: result.data!)
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
    
    func applyTransferSinpe(){
        self.showBusyIndicator("Loading Data")
        let request: WalletTransferRequest = WalletTransferRequest()
        request.aliasNameOrigin = (self.accountToUse?.aliasName)!
        request.destinationPhoneNumber = self.contactToUse.phoneNumber.replacingOccurrences(of: "-", with: "")
        request.nameAccountOrigin = (self.accountToUse?.name)!
        request.reason = self.desc as NSString
        request.total = Int(self.amount)!
        request.walletId = (self.accountToUse?.walletId)!
        ProxyManager.WalletApplyTransfer(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    for item in (result.data?.detail?.list)! {
                        if item.key.lowercased.range(of: "comprobante") != nil {
                            self.voucher = item.value.description
                        }
                    }
                    self.showBill()
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
    
    func applyTransfer(){
        self.showBusyIndicator("Loading Data")
        let request: TransferRequest = TransferRequest()
        request.aliasNameDestination = (self.fromAccount?.aliasName)!
        request.aliasNameOrigin = (self.accountToUse?.aliasName)!
        request.nameAccountDestination = (self.fromAccount?.name)!
        request.nameAccountOrigin = (self.accountToUse?.name)!
        request.reason = NSString(string: self.desc)
        request.total = NSDecimalNumber(string: self.amountFinal)
        request.typeTransfer = self.transferType!.id
        ProxyManager.ApplyTransfer(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    for item in (result.data?.detail?.list)! {
                        if item.key.lowercased.range(of: "comprobante") != nil {
                            self.voucher = item.value.description
                        }
                    }
                    self.showBill()
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
    
    func showBill(infoConfirm: ReceiptService, infoPay: ReceiptService){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BillViewController") as! BillViewController
        switch (self.typeProduct) {
        case 1:
            let formatter = DateFormatter()
            formatter.amSymbol = "a.m."
            formatter.pmSymbol = "p.m."
            formatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let resultDate = formatter.string(from: Date())
            vc.titleBill = "Pago Exitoso"
            vc.confirmDesc = "El pago se realizó exitosamente"
            vc.actionDesc = "Monto Cancelado"
            vc.accountToUse = self.accountToUse
            vc.serviceToPay = infoConfirm
            vc.mainViewController = self.mainViewController
            vc.modalReceipt = self
            vc.sectionType = "servicios"
            vc.amount = (self.serviceToPay?.total)!
            vc.info1 = infoPay.transactionId.description
            vc.info2 = resultDate
            vc.info3 = (self.productSelect as! PaymentService).aliasServiceName as String
            break;
        case 2:
            vc.titleBill = "Pago Exitoso"
            vc.confirmDesc = ""
            vc.actionDesc = "Monto Cancelado"
            vc.accountToUse = self.accountToUse
            vc.serviceToPay = infoPay
            vc.mainViewController = self.mainViewController
            vc.modalReceipt = self
            vc.sectionType = "creditos"
            vc.amount = (self.serviceToPay?.total)!
            vc.info1 = self.creditType
            vc.info2 = self.creditAlias
            break
        default:
            print("default")
            break;
        }
        self.present(vc, animated: true)
    }
    
    func showBill(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BillViewController") as! BillViewController
        switch (self.typeProduct) {
        case 3:
            let formatter = DateFormatter()
            formatter.amSymbol = "a.m."
            formatter.pmSymbol = "p.m."
            formatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let resultDate = formatter.string(from: Date())
            vc.titleBill = "Transferencia Exitosa"
            vc.confirmDesc = "Tipo de Transferencia: SINPE Móvil"
            vc.actionDesc = "Monto Transferencia"
            vc.accountToUse = self.accountToUse
            vc.contactToUse = self.contactToUse
            vc.mainViewController = self.mainViewController
            vc.modalReceipt = self
            vc.sectionType = "sinpe"
            vc.amount = "¢" + Helper.formatAmount(Int(self.amount)! as NSNumber)
            vc.info1 = self.desc
            vc.info2 = self.voucher
            vc.info3 = resultDate
            vc.charge = self.charge
            vc.sinpeCharge = self.sinpeCharge
            break
        case 4:
            let formatter = DateFormatter()
            formatter.amSymbol = "a.m."
            formatter.pmSymbol = "p.m."
            formatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let resultDate = formatter.string(from: Date())
            vc.titleBill = "Transferencia Exitosa"
            vc.confirmDesc = "Tipo de Transferencia: " + self.transferType.name.description
            vc.actionDesc = (self.transferType.id.description.range(of:"1") != nil)
                ? ((self.fromAccount.currencySign == self.accountToUse.currencySign) ? "Monto Debitado" : "Monto Acreditado")
                : "Monto Debitado"
            vc.accountToUse = self.accountToUse
            vc.fromAccount = self.fromAccount
            vc.amountFinal = self.amountFinal
            vc.transferType = self.transferType
            vc.exchangeRate = self.exchangeRate
            vc.debitAmount = self.debitAmount
            vc.mainViewController = self.mainViewController
            vc.modalReceipt = self
            vc.sectionType = "transferencias"
            vc.amount = self.lblTotal.text!
            vc.info1 = self.desc
            vc.info2 = self.voucher
            vc.info3 = resultDate
            break
        default:
            print("default")
            break;
        }
        self.present(vc, animated: true)
    }
    
}
