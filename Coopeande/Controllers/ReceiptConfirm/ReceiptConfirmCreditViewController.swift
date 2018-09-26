//
//  ReceiptConfirmCreditViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ReceiptConfirmCreditViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var lblCreditType: UILabel!
    @IBOutlet weak var lblCreditAlias: UILabel!
    @IBOutlet weak var viewActionDesc: UIView!
    @IBOutlet weak var lblConfirmDesc: UILabel!
    @IBOutlet weak var lblActionDesc: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewMainReceipt: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblAccountAlias: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    
    var logo: UIImage? = nil
    var creditType: String = ""
    var creditAlias: String = ""
    var titleScreen: String = ""
    var confirmDesc: String = ""
    var actionDesc: String = ""
    var accountToUse: Account! = nil
    var serviceToPay: ReceiptService! = nil
    var productSelect: SelectableProduct! = nil
    var mainViewController: CreditDetailViewController!
    var operation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.productSelect != nil {
            self.productSelect = self.productSelect as! PayCreditType
        }
        self.imgLogo.image = self.logo
        self.lblTitleScreen.text = self.titleScreen
        self.lblCreditType.text = self.creditType
        self.lblCreditAlias.text = self.creditAlias
        self.lblConfirmDesc.text = self.confirmDesc
        self.lblActionDesc.text = self.actionDesc
        self.lblTotal.text = (self.serviceToPay?.total)!
        self.lblAccountName.text = self.accountToUse.name as String?
        self.lblAccountType.text = self.accountToUse.typeDescription as String?
        self.lblAccountAlias.text = self.accountToUse.aliasName as String?
        self.lblAccountNumber.text = "Cuenta IBAN  " + (self.accountToUse.sinpe as String?)!
        self.setDesign()
        //self.addSubViewController()
    }
    
    func setDesign(){
        self.viewActionDesc.layer.cornerRadius = 12.5
        self.btnAccept.layer.cornerRadius = 3
        self.btnCancel.layer.cornerRadius = 3
        self.viewBody.layer.cornerRadius = 10
        self.viewMainReceipt.layer.cornerRadius = 10
    }
    /*
    func addSubViewController(){
        if self.accountToUse != nil && self.serviceToPay != nil {
            let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptCreditSubViewController") as! DetailReceiptCreditSubViewController
            addChildViewController(subViewController)
            subViewController.view.frame = self.viewMainReceipt.bounds
            subViewController.set(service: self.serviceToPay, account: self.accountToUse, type: "", alias: "")
            self.viewMainReceipt.addSubview(subViewController.view)
        }
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.serviceToPay != nil) {
            return (self.serviceToPay?.detailList.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let pair = (self.serviceToPay?.detailList[indexPath.row])!
        if pair.key.lowercased.range(of: "monto") != nil {
            return 0
        }
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.serviceToPay != nil) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailReceiptCreditCell", for: indexPath) as! DetailReceiptCreditCell
            cell.show(pair: (self.serviceToPay?.detailList[indexPath.row])!)
            return cell
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        self.applyPayment()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func applyPayment(){
        self.showBusyIndicator("Loading Data")
        let request : PayCreditRequest = PayCreditRequest()
        request.accountAlias = self.accountToUse.aliasName as String
        request.operationId = self.operation
        request.receiveTypeId = (self.productSelect as! PayCreditType).id
        ProxyManager.GetPayCreditApply(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                    self.showBill(payInfo: result.data!)
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
    
    func showBill(payInfo: ReceiptService){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BillViewController") as! BillViewController
        vc.titleBill = "Pago Exitoso"
        vc.confirmDesc = ""
        vc.actionDesc = "Monto Cancelado"
        vc.accountToUse = self.accountToUse
        vc.serviceToPay = payInfo
        vc.mainViewController = self.mainViewController
        vc.modalReceipt = self
        vc.sectionType = "creditos"
        vc.info1 = self.creditType
        vc.info2 = self.creditAlias
        self.present(vc, animated: true)
    }
    
}
