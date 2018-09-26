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
    @IBOutlet weak var tvDescription: UITextView!

    @IBOutlet weak var btnDo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let btn = self.navigationController?.navigationBar.backItem?.backBarButtonItem {
            btn.title = "<"
            btn.tintColor = Style.mainColor1
        }
        showPasswordRequirement()
        
        txtUser.inputAccessoryView =  self.getKeyboardToolbarForTextField(txtUser);
        txtActual.inputAccessoryView =  self.getKeyboardToolbarForTextField(txtActual);
        txtNewPassword.inputAccessoryView =  self.getKeyboardToolbarForTextField(txtNewPassword);
        txtNewPasswordConfirm.inputAccessoryView =  self.getKeyboardToolbarForTextField(txtNewPasswordConfirm);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "swPasswordKeyboard"
        {
            if let sg = segue.destination as? PasswordKeyboard
            {
                sg.delegate = self
            }
        }
    }
    
    func isValidData() -> Bool
    {
        if(txtUser.text?.isEmpty)!
        {
            self.showAlert("Change Password Title", messageKey: "Username is required")
            return false;
        }
        if(Helper.isNumber(txtUser.text) == false){
            self.showAlert("Invalid Data Title", messageKey: "Username can only have numbers")
        }
        if(txtActual.text?.isEmpty)!
        {
            self.showAlert("Change Password Title", messageKey: "Password is required")
            return false;
        }
        if(txtNewPassword.text?.isEmpty)!
        {
            self.showAlert("Change Password Title", messageKey: "New Password is required")
            return false;
        }
        if(txtNewPasswordConfirm.text?.isEmpty)!
        {
            self.showAlert("Change Password Title", messageKey: "New Password confirmation is required")
            return false;
        }
        if(txtNewPassword.text != txtNewPasswordConfirm.text)
        {
            self.showAlert("Change Password Title", messageKey: "Your password and confirmation password do not match.")
            return false;
        }
        
        return true
    }
    
    func showPasswordRequirement()
    {
        //self.showBusyIndicator("in process")
        ProxyManager.GetPoliciesAboutPassword({
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    //self.hideBusyIndicator()
                    //OperationQueue.mainQueue().addOperationWithBlock(
                    self.tvDescription.text = Helper.parseText(result.message as String)
                }
            })
        },
            failure: { (error) -> Void in
                //self.hideBusyIndicator()
                self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(Constants.iPad)
        {
           /* if(string.count>0)
            {
                let dictionary :String  = (textField.tag == 1 ? "0123456789" : "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890")
                
                let myCharSet : CharacterSet = CharacterSet(charactersIn: dictionary)
                for i in 0...string.count-1
                {
                    let c : unichar = string.characterAtIndex(index: i)
                    let test = myCharSet.contains(UnicodeScalar(c)!)
                    if (!test) {
                        return false;
                    }
                }
            }*/
            if(flag)
            {
                if(range.length == 1)
                {
                    //textField.text = textField.text.substringToIndex(textField.text.endIndex.predecessor())
                    textField.text = textField.text?.substring(to: (textField.text?.index(before: (textField.text?.endIndex)!))!)
                }
                else
                {
                    textField.text = textField.text! + string
                }
                return false;
                
            }
            
        }
        return true;
    }
    
    ///Mark PasswordKeyDelegate
    func PasswordKey(_ key:String)
    {
        let textView = txtActual.isFirstResponder ? txtActual : txtNewPassword.isFirstResponder ? txtNewPassword : txtNewPasswordConfirm
        
        if( key == NSString(format: "%c",13) as String)
        {
            switch (textView?.text?.count as Int!)
            {
                
            case 0...1:
                textView?.text = ""
                break;
            default:
                //var toIndex = textView?.text?.endIndex.predecessor()
                let toIndex = textView?.text?.index(before: (textView?.text?.endIndex)!)
                //textView?.text = textView?.text.substringToIndex(toIndex)
                textView?.text = textView?.text?.substring(to: toIndex!)
                break
                
            }
        }
        else
        {
            textView?.text = (textView?.text!)! +  key
        }
    }
    
    /*func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        super.alertView(alertView, clickedButtonAt: buttonIndex)
        if (dismissThis)
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func modalAlertOk(_ action: UIAlertAction) {
        if (dismissThis)
        {
            self.navigationController?.popViewController(animated: true)
        }
    }*/

}
