//
//  SinpeConfirmViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/22/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SinpeConfirmViewController: BaseViewController {

    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitleConfirm: UILabel!
    @IBOutlet weak var lblConfirmation: UILabel!
    @IBOutlet weak var lblIban: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var titleScreen: String = ""
    var titleConfirm: String = ""
    var confirmation: String = ""
    var phoneNumber: String = ""
    var accountToUse: Account? = nil
    var operationType: String = ""
    var afiliateController: AffiliationViewController?
    var disafiliateController: DisaffiliationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
        self.lblTitleScreen.text = self.titleScreen
        self.lblTitleConfirm.text = self.titleConfirm
        self.lblConfirmation.text = confirmation
        self.lblPhoneNumber.text = "Teléfono: " + self.phoneNumber
        self.lblIban.text = self.accountToUse?.iban.description
        self.lblName.text = self.accountToUse?.name.description
    }
    
    func setDesign(){
        self.viewPhone.layer.cornerRadius = 12.5
        self.btnAccept.layer.cornerRadius = 3
        self.btnCancel.layer.cornerRadius = 3
        self.viewContent.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        switch self.operationType {
        case "afiliar":
            self.afiliate()
            break
        case "desafiliar":
            self.disafiliate()
            break
        default:
            print("default")
            break
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func afiliate(){
        self.showBusyIndicator("Loading Data")
        let request: WalletAfilliateNumberRequest = WalletAfilliateNumberRequest()
        request.aliasName = (self.accountToUse?.aliasName)!
        request.phoneNumber = self.phoneNumber.replacingOccurrences(of: "-", with: "") as NSString
        ProxyManager.Afiliate(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dismiss(animated: true, completion: {self.afiliateController?.afiliateSuccess(message: result.message.description)})
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
    
    func disafiliate(){
        self.showBusyIndicator("Loading Data")
        let request: WalletAccountInactivateRequest = WalletAccountInactivateRequest()
        request.walletId = (self.accountToUse?.walletId)!
        ProxyManager.WalletAccountInactivate(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dismiss(animated: true, completion: {self.disafiliateController?.disafiliateSuccess(message: result.message.description)})
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
    
}
