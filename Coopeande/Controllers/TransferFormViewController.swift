//
//  TransferFormViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class TransferFormViewController: UITableViewController, SelectedAccountBackDelegate, SelectedTrasferTypeBackDelegate, UITextFieldDelegate
{
    var ProxyManager :UtilProxyManager = UtilProxyManager()

    @IBOutlet weak var cuentaOrigenLabel: UILabel!
    @IBOutlet weak var montoOrigenLabel: UILabel!
    @IBOutlet weak var cuentaDestinoLabel: UILabel!
    @IBOutlet weak var comisionTransferencia: UILabel!
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var txtDescripcionTransferencia: UITextField!
    
    func SelectedTrasferTypeBackDelegate() {}
    
    var inputDataChangeDelegate : InputDataChangeDelegate?
    var sessionTimeOutDelegate : SessionTimeOutDelegate?
    
    var selectedAccountFrom: Account?
    var selectedAccountTo: Account?
    var selectedTransferType : TransferType?
    var currentString = ""
    var currencySign : String = ""
    var transferRequest  = TransferRequest()
    var transferToSubmit : TransferRequest
    {
        get{
            transferRequest.reason = txtDescripcionTransferencia.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let castData = formatter.number(from: txtMonto.text!)
            {
                transferRequest.total  = NSDecimalNumber(value:castData.floatValue)
            }
            return transferRequest
        }
    }
    var transferAccounts : TransferAccounts?
    var removedFromParent :Bool = false
    
    override func removeFromParentViewController() {
        removedFromParent = true
        super.removeFromParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToolButtonToKeyboard()
        
        let headerView = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1 / UIScreen.main.scale)
        let lineTop = UIView(frame: headerView)
        let topSeparator = CGRect(x: self.tableView.separatorInset.left, y: 0, width: self.tableView.frame.size.width - self.tableView.separatorInset.left - self.tableView.separatorInset.right, height:  1 / UIScreen.main.scale)
        let line = UIView(frame: topSeparator)
        line.backgroundColor = self.tableView.separatorColor
        lineTop.addSubview(line)
        self.tableView.tableHeaderView = lineTop


        //print("Id Elegido: ",transferAccounts?.accountFromCount)
        
        //comisionTransferencia.text = Helper.formatAmount(selectedTransferType?.commission!, currencySign: selectedTransferType?.currencySign as! String)
        
        getAccountsByTransferType(trasferTypeId: "01")
    }
    
    
    func addToolButtonToKeyboard()
    {
        let myToolbar : UIToolbar =  UIToolbar();
        //myToolbar.barStyle = UIBarStyle.Black
        myToolbar.isTranslucent = true;
        myToolbar.isUserInteractionEnabled = true;
        myToolbar.sizeToFit();
        let btnOK = UIBarButtonItem(title:Helper.getLocalizedText("Ok"), style: .plain, target: self, action: #selector(doneClicked(sender:)))
        btnOK.setTitleTextAttributes(Style.navButtonTextAttributes as? [NSAttributedStringKey : Any], for: UIControlState.normal)
        myToolbar.setItems([btnOK], animated: true);
        
        txtMonto.inputAccessoryView = myToolbar;
        txtDescripcionTransferencia.inputAccessoryView = myToolbar;
    }
    func hideKeyboard()
    {
        txtMonto.endEditing(true)
        txtDescripcionTransferencia.endEditing(true)
        
    }
    
    @objc func doneClicked (sender : UIBarButtonItem)
    {
        txtMonto.endEditing(true)
        txtDescripcionTransferencia.endEditing(true)
    }
    @IBAction func editingDidEnd (sender : UITextField)
    {
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        //formatter.locale = NSLocale(localeIdentifier: "es_CR")
        //var numberFromField = (NSString(string: sender.text).floatValue)
        if let numberFromField = formatter.number(from: sender.text!)
        {
            
            txtMonto.text = formatter.string(from: numberFromField)
            
        }
        propagateInputDataChangeDelegate()
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var result : Bool = true
        var message : String = ""
        print("Id Elegido1: ",self.transferAccounts?.accountFromCount)
        if(identifier != "swTipoTransferencia")
        {
            if let ta = self.transferAccounts
            {
                if identifier == "FromAccountsByTransferType"
                {
                    if !(ta.list.count > 0)
                    {
                        message = "No Accounts"
                        result = false
                    }
                }
                if identifier == "ToAccountsByTransferType"
                {
                    if !(ta.destinationAccounts.count > 0)
                    {
                        message = "No Accounts"
                        result = false
                    }
                }
            }
            else
            {
                message = "Select type of transfer"
                result =  false
            }
        }
        if !result
        {
            self.showAlert("Invalid Data Title", messageKey: message)
        }
        return result
    }
    func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Entro al segue")
        if(segue.identifier != "swTipoTransferencia")
        {
            let controller = segue.destination as! AccountListViewController
            controller.delegate = self
            if( segue.identifier! == "FromAccountsByTransferType")
            {
                controller.dataResponse = self.transferAccounts!.list
            }
            else
            {
                controller.tipoCuenta = AccountType.to
                controller.dataResponse = self.transferAccounts!.destinationAccounts
            }
        }
        else
        {
            /*
            var controller = segue.destination as! TransferTypeViewController
            
            if let currentTransferType = self.selectedTransferType?.id
            {
                controller.SelectedTransferTypeId = currentTransferType
            }
            
            controller.delegate = self
            controller.sessionTimeOutDelegate = self.sessionTimeOutDelegate*/
        }
        
    }
    
    ///MAR SelectedAccountBackDelegate
    
    func SelectedAccountBack(selectedValue selectedAccount: Account, type: AccountType)
    {
        print("Retorno de seleccionar cuenta")
        if( type == AccountType.to)
        {
            selectedAccountTo = selectedAccount
            transferRequest.aliasNameDestination = selectedAccount.aliasName
            transferRequest.nameAccountDestination = selectedAccount.name
            
            cuentaDestinoLabel.text = selectedAccount.aliasName as String
            
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = NSNumber(value: 0.9)
            animation.duration = 0.3
            animation.repeatCount = 4.0
            animation.autoreverses = true
            //moneda.layer.addAnimation(animation, forKey: nil)
            //moneda.text = selectedAccount.currencySign
            
            self.currencySign = selectedAccount.currencySign as String
            propagateInputDataChangeDelegate()
        }
        else
        {
            print("Selected account: ",selectedAccount.account)
            selectedAccountFrom = selectedAccount
            transferRequest.aliasNameOrigin = selectedAccount.aliasName
            transferRequest.nameAccountOrigin = selectedAccount.name
            
            cuentaOrigenLabel.text = selectedAccount.aliasName as String
            montoOrigenLabel.text = Helper.formatAmount(selectedAccount.availableBalance,
                                                        currencySign: selectedAccount.currencySign as String)
            
            propagateInputDataChangeDelegate()
            
        }
    }
    
    
    ///MARK UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        propagateInputDataChangeDelegate()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        propagateInputDataChangeDelegate()
        return true;
    }
    
    ///MARK Helper
    
    func isRequiredDataReady() -> (Bool,String)
    {
        let result = (true,"")
        if( self.transferToSubmit.typeTransfer.length == 0)
        {
            return   (false,"Select type of transfer")
        }
        if( self.transferToSubmit.aliasNameOrigin.length == 0)
        {
            
            return  (false,"Select destination account")
        }
        if( self.transferToSubmit.aliasNameDestination.length == 0)
        {
            return (false,"Select source account")
        }
        if( self.transferToSubmit.reason.length == 0)
        {
            return   (false,"Input the reason to transfer")
        }
        //        if( self.transferToSubmit.reason.length < 15)
        //        {
        //            return   (false,"Input the reason to transfer greatter than 15")
        //        }
        
        if let amount = self.transferToSubmit.total
        {
            if amount == 0
            {
                return   (false,"Input the amout to transfer")
            }
        }
        else
        {
            return  (false,"Input only number for the amount")
        }
        
        return result
    }
    private func propagateInputDataChangeDelegate()
    {
        if let delegate = inputDataChangeDelegate
        {
            delegate.inputDataChange()
        }
        
    }
    func cleanData()
    {
        self.showBusyIndicator("")
        OperationQueue.main.addOperation({
            self.txtDescripcionTransferencia.text = ""
            self.txtDescripcionTransferencia.text = ""
            self.txtMonto.text = ""
            self.transferRequest = TransferRequest()
            self.selectedAccountFrom = nil
            self.selectedAccountTo = nil
            //self.tipoTransferencia.text = Helper.getLocalizedText("Select a transfer type")
            self.cuentaOrigenLabel.text = Helper.getLocalizedText("Select source account")
            self.cuentaDestinoLabel.text = Helper.getLocalizedText("Select destination account")
            //self.moneda.text = Helper.getLocalizedText("")
            
            self.comisionTransferencia.text = Helper.getLocalizedText("0")
            self.montoOrigenLabel.text = Helper.getLocalizedText("")
            self.transferAccounts = nil
            self.hideBusyIndicator()
            
        })
    }
    func getAccountsByTransferType(trasferTypeId : String)
    {
        print("Id Elegido1: ",transferAccounts?.accountFromCount)
        let request : TransferAccountsRequest = TransferAccountsRequest()
        request.transferTypeId = trasferTypeId
        self.showBusyIndicator( "Loading Data")
        ProxyManager.AccountsByTransferType(data: request, success: {
            (result) in
            if(!self.removedFromParent)
            {
                self.hideBusyIndicator()
                DispatchQueue.main.async() {
                if result.isSuccess
                {
                        self.transferAccounts = result.data
                        print("Pinta aqui")
                }
                else
                {
                    if(self.sessionTimeOutDelegate!.onSessionTimeOutException(code: result.code as String) == false)
                    {
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
                }
            }}, failure: { (error) -> Void in                if(!self.removedFromParent)
            {
                self.refreshControl?.endRefreshing()
                self.hideBusyIndicator()
                self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                }
        })
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField.tag == 2
        {
            return Helper.formatAnyNumberOrAmount(textField, shouldChangeCharactersInRange: range, replacementString: string, maxAmountDigits: 10, formatIndicator: 0);
        }
        else
        {
            return true
        }
        
    }
    
    func SelectedTransferTypeBack(selectedTransferType : TransferType)
    {
        print("Entro acá.")
        print("id seleccionado: ", selectedTransferType.id)
        /*self.selectedTransferType = selectedTransferType
        transferRequest.typeTransfer = selectedTransferType.id
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        
        var comissionValue = formatter.string(from: selectedTransferType.commission!)
        //tipoTransferencia.text = selectedTransferType.name
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 0.9)
        animation.duration = 0.3
        animation.repeatCount = 4.0
        animation.autoreverses = true
        comisionTransferencia.layer.add(animation, forKey: nil)
        
        comisionTransferencia.text = Helper.formatAmount(selectedTransferType.commission!, currencySign: selectedTransferType.currencySign as String)
        
        getAccountsByTransferType(trasferTypeId: selectedTransferType.id as String)
        
        selectedAccountFrom = nil
        selectedAccountTo = nil
        
        self.cuentaOrigenLabel.text = "Seleccione la cuenta origen"
        montoOrigenLabel.text = ""
        self.cuentaDestinoLabel.text = "Seleccione la cuenta destino"
        
        self.txtMonto.text = ""
        self.txtDescripcionTransferencia.text = ""
        
        propagateInputDataChangeDelegate()*/
        
    }
    
    
    
    
}
