//
//  CreditMovementsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CreditMovementsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var lblActualAmount: UILabel!
    @IBOutlet weak var lblCreditType: UILabel!
    @IBOutlet weak var lblCreditAlias: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblOperacion: UILabel!
    @IBOutlet weak var movementsTableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblIban: UILabel!
    @IBOutlet weak var lblIbanHeight: NSLayoutConstraint!
    @IBOutlet weak var lblOwnerHeight: NSLayoutConstraint!
    
    var creditMovements: Array<CreditTransaction> = []
    var walletMovements: Array<Statement> = []
    var actualAmount: String = ""
    var type: String = ""
    var alias: String = ""
    var owner: String = ""
    var operation: String = ""
    var walletId: String = ""
    var account: String = ""
    var currency: String = ""
    var subTitle: String = ""
    var iban: String = ""
    var sectionType: Int = 0 // 0 -> creditos, 1 -> sinpe, 2 -> transaccion
    
    struct Objects {
        var sectionName: String!
        var sectionObjects: [Statement]!
    }
    
    var objectArray: [Objects] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movimientos"
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.44, blue:0.78, alpha:1.0)
        self.viewHeader.layer.cornerRadius = 12.5
        self.lblActualAmount.text = self.actualAmount
        self.lblSubTitle.text = self.subTitle
        self.lblIban.text = self.iban
        if self.iban == "" {
            self.lblIbanHeight.constant = 0
            self.lblIban.layoutIfNeeded()
        }
        self.lblCreditType.text = self.type
        self.lblCreditAlias.text = self.alias
        self.lblOwner.text = self.owner
        if self.sectionType == 0 {
            self.lblIban.text = ""
            self.lblOperacion.text = (self.iban != "") ? "Operación " + self.iban : ""
        }
        if self.sectionType == 2 {
            self.lblOwnerHeight.constant = 0
            self.lblOwner.layoutIfNeeded()
            self.lblOperacion.text = (self.operation != "") ? "Cuenta IBAN " + self.operation : ""
        }
        switch self.sectionType {
        case 0:
            self.loadGetAllCreditTransaction()
            break
        case 1:
            self.loadGetAllWalletTransaction()
            self.lblCreditAlias.font = UIFont.systemFont(ofSize: 13)
            break
        case 2:
            self.loadAccountTransaction()
            break
        default:
            print("default")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            if self.movementsTableView != nil {
                self.movementsTableView.reloadData()
            }
        }
    }
    
    func groupStatements(){
        self.objectArray = []
        _ = (self.walletMovements.map({(state) -> Bool in
            if self.objectArray.count < 1 {
                self.objectArray.append(Objects(sectionName: state.dateGroup, sectionObjects: [state]))
            }
            else{
                var added = false
                for i in 0..<self.objectArray.count {
                    if self.objectArray[i].sectionName == state.dateGroup{
                        self.objectArray[i].sectionObjects.append(state)
                        added = true
                    }
                }
                if !added {
                    self.objectArray.append(Objects(sectionName: state.dateGroup, sectionObjects: [state]))
                }
            }
            return true
        }))
        self.movementsTableView.reloadData()
        self.hideBusyIndicator()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sectionType == 1 || self.sectionType == 2{
            if self.objectArray.count > 0 {
                return self.objectArray[section].sectionObjects.count
            }
        }
        else{
            if self.sectionType == 0 {
                return self.creditMovements.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if self.sectionType == 1 || self.sectionType == 2{
            view.tintColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0)
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if self.sectionType == 1 || self.sectionType == 2 {
            return self.objectArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sectionType == 1 || self.sectionType == 2 {
            if self.objectArray.count > 0 {
                return objectArray[section].sectionName
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if self.sectionType == 1 || self.sectionType == 2 {
            return 70
        }
        else{
            if self.sectionType == 0 {
                return 135
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.movementsTableView.separatorStyle = .singleLine
        self.movementsTableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.movementsTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        if self.sectionType == 1 || self.sectionType == 2 {
            self.movementsTableView.estimatedRowHeight = 70
            self.movementsTableView.rowHeight = 70
            let cell = self.movementsTableView.dequeueReusableCell(withIdentifier: "SinpeMovement", for: indexPath) as! SinpeMovementCell
            let w = self.objectArray[indexPath.section].sectionObjects[indexPath.row]
            cell.show(mov: w, currency: self.currency, type: self.sectionType)
            let border1 = CALayer()
            border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
            border1.frame = CGRect(x: (cell.viewDate.bounds.width) - 1, y: 3, width: 1, height: cell.viewDate.bounds.height - 8)
            border1.borderWidth = 1
            cell.viewDate.layer.addSublayer(border1)
            cell.viewDate.layer.masksToBounds = true
            /*let border = CALayer()
            border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
            border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: UIScreen.main.bounds.width - 30, height: 1)
            border.borderWidth = 1
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true*/
            return cell
        }
        else{
            if self.sectionType == 0 {
                self.movementsTableView.estimatedRowHeight = 135
                self.movementsTableView.rowHeight = 135
                let cell = self.movementsTableView.dequeueReusableCell(withIdentifier: "CreditMovement", for: indexPath) as! CreditMovementCell
                let t = self.creditMovements[indexPath.row]
                cell.show(quota: t.quota, main: t.main, interest: t.interest, moratorium: t.moratorium, others: t.other, document: t.document, amount: t.totalBalance, day: t.day, month: t.month, currency: self.currency)
                let border1 = CALayer()
                border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
                border1.frame = CGRect(x: (cell.viewDate.bounds.width) - 1, y: 3, width: 1, height: cell.viewDate.bounds.height - 8)
                border1.borderWidth = 1
                cell.viewDate.layer.addSublayer(border1)
                cell.viewDate.layer.masksToBounds = true
                /*let border = CALayer()
                border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
                border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: UIScreen.main.bounds.width - 30, height: 1)
                border.borderWidth = 1
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true*/
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func loadGetAllCreditTransaction(){
        self.showBusyIndicator("Loading Data")
        let request = GetAllCreditTransactionRequest()
        request.operation = self.operation as NSString
        ProxyManager.GetAllCreditTransaction(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    let count = result.data?.list.count
                    if count! > 0 {
                        self.creditMovements = (result.data?.list)!
                        self.movementsTableView.reloadData()
                        self.hideBusyIndicator()
                    }
                    else{
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: "No posee movimientos")
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

    func loadGetAllWalletTransaction(){
        self.showBusyIndicator("Loading Data")
        let request = WalletStatementsRequest()
        request.walletId = self.walletId
        ProxyManager.GetWalletAccountMovements(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    let count = result.data?.list.count
                    if count! > 0 {
                        self.walletMovements = (result.data?.list)!
                        self.groupStatements()
                    }
                    else{
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: "No posee movimientos")
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
    
    func loadAccountTransaction(){
        self.showBusyIndicator("Loading Data")
        let request = StatementsRequest()
        request.account = NSString(string: self.account)
        ProxyManager.AccountMovements(request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    let count = result.data?.list.count
                    if count! > 0 {
                        self.walletMovements = (result.data?.list)!
                        self.groupStatements()
                    }
                    else{
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: "No posee movimientos")
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
    
}
