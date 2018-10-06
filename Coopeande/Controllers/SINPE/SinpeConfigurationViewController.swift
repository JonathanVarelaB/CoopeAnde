//
//  SinpeConfigurationViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SinpeConfigurationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnChange: UIButton!
    
    var maxAmountCell: MaxAmountCell! = nil
    var notificationsCell: NotificationsCell! = nil
    let kHeaderSectionTag: Int = 6900;
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionNames: Array<Any> = []
    var configTransfer: WalletTransferAmountStatement! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardEvent()
        sectionNames = [ "Monto Máximo a Transferir", "Notificaciones Recibidas"];
        self.btnChange.layer.cornerRadius = 3
        self.hideKeyboardWhenTappedAround()
        self.loadConfiguration()
    }
    
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(SinpeConfigurationViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SinpeConfigurationViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        self.view.frame.origin.y = -170
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.isHidden = true

        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        border.frame = CGRect(x: 15, y: 0, width: (header.frame.size.width) - 30, height: 1)
        border.borderWidth = 1
        header.layer.addSublayer(border)
        header.layer.masksToBounds = true
        
        let headerLabel: UILabel = UILabel()
        headerLabel.frame = CGRect(x: 30, y: 23, width: tableView.frame.size.width - 65, height: 18)
        headerLabel.backgroundColor = UIColor.white
        headerLabel.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
        headerLabel.numberOfLines = 1
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.font = UIFont.boldSystemFont(ofSize: 15)
        headerLabel.text = (section > 0) ? "Notificaciones Recibidas" : "Monto Máximo a Transferir"
        header.addSubview(headerLabel)
        
        let headerSubLabel: UILabel = UILabel()
        headerSubLabel.frame = CGRect(x: 30, y: 41, width: tableView.frame.size.width - 65, height: 17)
        headerSubLabel.backgroundColor = UIColor.white
        headerSubLabel.textColor = UIColor.black
        headerSubLabel.numberOfLines = 1
        headerSubLabel.adjustsFontSizeToFitWidth = true
        headerSubLabel.font = UIFont.systemFont(ofSize: 12)
        headerSubLabel.text = (section > 0) ? "Active las notificaciones recibidas de SINPE Móvil" : "Actualice el monto máximo a transferir por SINPE Móvil"
        header.addSubview(headerSubLabel)
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 30, y: 35, width: 15, height: 10));
        theImageView.image = UIImage(named: "row")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(SinpeConfigurationViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
            if self.notificationsCell == nil{
                self.notificationsCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
                if self.configTransfer != nil {
                    self.notificationsCell.txtEmail.text = self.configTransfer.email.description
                    self.notificationsCell.switchNotifications.isOn = self.configTransfer.isSendNotificationEmail
                    self.notificationsCell.txtEmail.delegate = self
                }
            }
            return self.notificationsCell
        }
        else{
            if self.maxAmountCell == nil{
                self.maxAmountCell = tableView.dequeueReusableCell(withIdentifier: "MaxAmountCell", for: indexPath) as! MaxAmountCell
                if self.configTransfer != nil {
                    self.maxAmountCell.txtAmount.text = self.configTransfer.maxAmountByApplication.description
                    self.validAmount()
                }
            }
            return self.maxAmountCell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        self.expandedSectionHeaderNumber = -1;
        UIView.animate(withDuration: 0.4, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
        })
        var indexesPath = [IndexPath]()
            let index = IndexPath(row: 0, section: section)
            indexesPath.append(index)
        self.tableView!.beginUpdates()
        self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.tableView!.endUpdates()
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        UIView.animate(withDuration: 0.4, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        })
        var indexesPath = [IndexPath]()
            let index = IndexPath(row: 0, section: section)
            indexesPath.append(index)
        self.expandedSectionHeaderNumber = section
        self.tableView!.beginUpdates()
        self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.tableView!.endUpdates()
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        self.notificationsCell.txtEmail.text = ""
        self.notificationsCell.txtEmail.isHidden = !sender.isOn
        self.validForm()
    }
    
    @IBAction func changeEmail(_ sender: UITextField) {
       self.validForm()
    }
    
    @IBAction func changeAmount(_ sender: UITextField) {
        self.validAmount()
    }
    
    func validAmount(){
        self.maxLenght(textField: self.maxAmountCell.txtAmount, maxLength: 11)
        let amountIn = self.maxAmountCell.txtAmount.text
        if amountIn != "" {
            (self.maxAmountCell.txtAmount.leftView as! UILabel).text = "   ¢"
            let amount = Helper.removeFormatAmount(amountIn)
            self.maxAmountCell.txtAmount.text = Helper.formatAmountInt(amount)
        }
        else{
            (self.maxAmountCell.txtAmount.leftView as! UILabel).text = ""
        }
        self.validForm()
    }
    
    @IBAction func change(_ sender: UIButton) {
        self.showBusyIndicator("Loading Data")
        let request: WalletTransferAmountsRequest = WalletTransferAmountsRequest()
        let amountSend = (self.maxAmountCell != nil)
            ? Helper.removeFormatAmount(self.maxAmountCell.txtAmount.text)
            : self.configTransfer.maxAmountByApplication.description
        if self.notificationsCell != nil {
            request.isSendNotificationEmail = self.notificationsCell.switchNotifications.isOn
            request.email = self.notificationsCell.txtEmail.text!
        }
        else{
            request.isSendNotificationEmail = self.configTransfer.isSendNotificationEmail
            request.email = self.configTransfer.email.description
        }
        request.isSendNotificationSMS = false
        request.maxAmountBySMS = Int(amountSend)!
        request.maxAmountByApplication = Int(amountSend)!
        ProxyManager.SetMaxAmountTransferValues(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.hideBusyIndicator()
                     self.showAlert("Cambio Exitoso", messageKey: result.message.description)
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
    
    func validForm(){
        self.enableButton(btn: self.btnChange)
        if self.maxAmountCell != nil {
            if self.maxAmountCell.txtAmount.text == "" || self.maxAmountCell.txtAmount.text == "0" {
                self.disableButton(btn: self.btnChange)
                return
            }
        }
        if self.notificationsCell != nil && self.notificationsCell.switchNotifications.isOn {
            let email = self.notificationsCell.txtEmail.text
            if email == "" {
                self.disableButton(btn: self.btnChange)
                return
            }
            else{
                let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                if !emailPredicate.evaluate(with: email) {
                    self.disableButton(btn: self.btnChange)
                    return
                }
            }
        }
    }
    
    func loadConfiguration(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetWalletTransferAmounts(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.configTransfer = result.data
                    self.tableView.reloadData()
                    self.hideBusyIndicator()
                }
                else{
                    self.validForm()
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.validForm()
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
}
