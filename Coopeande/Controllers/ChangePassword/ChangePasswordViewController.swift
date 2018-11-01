//
//  ChangePasswordViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, PasswordKeyDelegate {

    var flag : Bool = true
    var dismissThis :Bool = false
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtActual: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewPasswordConfirm: UITextField!
    @IBOutlet weak var btnDo: UIButton!
    @IBOutlet weak var txtRules: UITextView!
    
    var lastTextActive: UITextField!
    var virtualKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cambio de Contraseña"
        self.txtActual.clearsOnInsertion = false
        self.txtActual.clearsOnBeginEditing = false
        self.txtNewPassword.clearsOnInsertion = false
        self.txtNewPassword.clearsOnBeginEditing = false
        self.txtNewPasswordConfirm.clearsOnInsertion = false
        self.txtNewPasswordConfirm.clearsOnBeginEditing = false
        self.backAction()
        self.keyboardEvent()
        self.setDesign()
        self.hideKeyboardWhenTappedAround()
        showPasswordRequirement()
    }
    
    func setDesign(){
        self.txtUser.delegate = self
        self.txtActual.delegate = self
        self.txtNewPassword.delegate = self
        self.txtNewPasswordConfirm.delegate = self
        self.btnDo.layer.cornerRadius = 3
        self.txtUser.layer.borderWidth = 0.7
        self.txtUser.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtUser.layer.cornerRadius = 4
        self.txtUser.leftViewMode = UITextFieldViewMode.always
        self.txtUser.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtUser.frame.height))
        self.txtActual.layer.borderWidth = 0.7
        self.txtActual.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtActual.layer.cornerRadius = 4
        self.txtActual.leftViewMode = UITextFieldViewMode.always
        self.txtActual.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtActual.frame.height))
        self.txtNewPassword.layer.borderWidth = 0.7
        self.txtNewPassword.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtNewPassword.layer.cornerRadius = 4
        self.txtNewPassword.leftViewMode = UITextFieldViewMode.always
        self.txtNewPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtActual.frame.height))
        self.txtNewPasswordConfirm.layer.borderWidth = 0.7
        self.txtNewPasswordConfirm.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtNewPasswordConfirm.layer.cornerRadius = 4
        self.txtNewPasswordConfirm.leftViewMode = UITextFieldViewMode.always
        self.txtNewPasswordConfirm.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtActual.frame.height))
    }
    
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 60
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUser:
            self.txtActual.becomeFirstResponder()
            break
        case txtActual:
            self.txtNewPassword.becomeFirstResponder()
            break
        case txtNewPassword:
            self.txtNewPasswordConfirm.becomeFirstResponder()
            break
        default:
            self.view.endEditing(true)
            break
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "swPasswordKeyboard"{
            if let sg = segue.destination as? PasswordKeyboard{
                sg.delegate = self
                sg.section = "change"
            }
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lastTextActive = textField
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        if Constants.iPhone {
            self.view.frame.origin.y = -90
        }
        else if UIApplication.shared.statusBarOrientation.isLandscape{
            if self.txtActual.isFirstResponder {
                self.view.frame.origin.y = 20
            }
            else if self.txtNewPassword.isFirstResponder {
                self.view.frame.origin.y = -30
            }
            else if self.txtNewPasswordConfirm.isFirstResponder {
                self.view.frame.origin.y = -80
            }
            else{
                self.view.frame.origin.y = 60
            }
        }
    }
    
    func PasswordKey(_ key: String) {
        if self.lastTextActive != nil && self.lastTextActive != self.txtUser {
            self.typeKey(key: key, textfield: self.lastTextActive)
        }
    }
    
    func typeKey(key: String, textfield: UITextField){
        if key == NSString(format: "%c",13).description {
            if (textfield.text?.count)! < 2{
                textfield.text = ""
            }
            else{
                textfield.text?.removeLast()
            }
        }
        else{
            if (textfield.text?.count)! < 30 {
                self.virtualKeyboard = true
                textfield.text = textfield.text! + key
            }
        }
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isValidData() -> Bool{
        if(txtUser.text?.isEmpty)!{
            self.showAlert("Change Password Title", messageKey: "Username is required")
            return false;
        }
        if(Helper.isNumber(txtUser.text) == false){
            self.showAlert("Invalid Data Title", messageKey: "Username can only have numbers")
        }
        if(txtActual.text?.isEmpty)!{
            self.showAlert("Change Password Title", messageKey: "Password is required")
            return false;
        }
        if(txtNewPassword.text?.isEmpty)!{
            self.showAlert("Change Password Title", messageKey: "New Password is required")
            return false;
        }
        if(txtNewPasswordConfirm.text?.isEmpty)!{
            self.showAlert("Change Password Title", messageKey: "New Password confirmation is required")
            return false;
        }
        if(txtNewPassword.text != txtNewPasswordConfirm.text){
            self.showAlert("Change Password Title", messageKey: "Your password and confirmation password do not match.")
            return false;
        }
        return true
    }
    
    func showPasswordRequirement(){
        ProxyManager.GetPoliciesAboutPassword({
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.txtRules.text = Helper.parseText(result.message as String)
                }
            })
        },
        failure: {(error) -> Void in
            DispatchQueue.main.async {
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }

    func validTxt(txt: UITextField){
        self.maxLenght(textField: txt, maxLength: 30)
        if txt.text?.last == " " {
            txt.deleteBackward()
        }
    }

    @IBAction func changeTxt(_ sender: UITextField) {
        if sender == self.txtUser {
            self.txtUser.text = Helper.validNumber(sender.text)
        }
        else {
            if Constants.iPad && !self.virtualKeyboard && (sender.text?.count)! > 0 {
                let ACCEPTABLE_CHARACTERS = "abcdefghijklmnopqrstuvwxyz0123456789"
                let last: String = (sender.text?.last!.description)!
                if ACCEPTABLE_CHARACTERS.range(of: last.lowercased()) == nil {
                    sender.text?.removeLast()
                }
            }
            self.virtualKeyboard = false
        }
        self.validTxt(txt: sender)
    }
    
    @IBAction func change(_ sender: UIButton) {
        if self.isValidData() {
            self.changePassword()
        }
    }
    
    func changePassword(){
        self.showBusyIndicator("Loading Data")
        let request = ChangePasswordRequest()
        request.user = NSString(string: self.txtUser.text!)
        request.password = NSString(string: self.txtActual.text!)
        request.newPassword = self.txtNewPassword.text!
        request.retypePass = self.txtNewPasswordConfirm.text!
        ProxyManager.ChangePassword(request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.hideBusyIndicator()
                    self.showAlert("Change Password Title", messageKey:"Your password has been changed!")
                    self.cleanForm()
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Change Password Title", messageKey: result.message.description)
                }
            })
        },
        failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func cleanForm(){
        self.txtUser.text = ""
        self.txtActual.text = ""
        self.txtNewPassword.text = ""
        self.txtNewPasswordConfirm.text = ""
    }
    
}
