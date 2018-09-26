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
    var typeProduct: Int = 0 // 1 -> servicios // 2 -> creditos // 3 -> sinpe
    var operation: String = ""
    var desc: String = ""
    var amount: String = ""
    var voucher: String = ""
    
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
            self.lblTotal.text = "¢" + Helper.formatAmount(a as NSNumber)
        }
        else{
            self.lblTotal.text = self.amount
        }
        self.setDesign()
        self.addSubViewController()
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
                self.viewMainReceiptHeight.constant = 126
                self.viewMainReceipt.layoutIfNeeded()
                let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptSinpeSubViewController") as! DetailReceiptSinpeSubViewController
                addChildViewController(subViewController)
                subViewController.view.frame = self.viewMainReceipt.bounds
                subViewController.set(account: self.accountToUse, description: self.desc, contact: self.contactToUse, bill: false)
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
        ProxyManager.PayBill(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                    self.showBill(infoConfirm: self.serviceToPay, infoPay: result.data!)
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
                        if item.key.lowercased.range(of: "doc") != nil {
                            self.voucher = item.value.description
                        }
                    }
                    self.showBill()
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
        //switch (self.typeProduct) {
        //case 3:
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
            /*break
        default:
            print("default")
            break;
        }*/
        self.present(vc, animated: true)
    }
    
}
