//
//  ViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Lottie

class LoginViewController: BaseViewController, PasswordKeyDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var logoAnimationView: UIView!
    @IBOutlet weak var itemMenuAnimation: UIView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    let animationView = LOTAnimationView(name: "menu")
    var statusMenuAnimation : Bool = false
    fileprivate var flag : Bool = false
    var password : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.logoTopConstraint.constant = 0
        menuView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        itemMenuAnimation.addSubview(animationView)
        animationView.loopAnimation = false
        //txtUsername.text = "401910830"
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtUsername.text = "304220057"
        txtPassword.text = "coope1234$"
        leftBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped(sender:))))
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "swPasswordKeyboard"{
            if let sg = segue.destination as? PasswordKeyboard{
                sg.delegate = self
            }
        }
    }
    
    @IBAction func doLogin(_ sender: AnyObject){
        let prefs = UserDefaults.standard
        var keyValue = prefs.string(forKey:"transferAccount")
        prefs.removeObject(forKey:"transferAccount")
        prefs.synchronize()
        
        if(Helper.isNumber(txtUsername.text) == false){
            self.showAlert("Invalid Data Title", messageKey: "Username can only have numbers")
        }
        else{
            let  entity: AnyObject = PreLoginRequest()
            self.showBusyIndicator("Signing in")
            if let request: PreLoginRequest  = entity as? PreLoginRequest{
                request.user = (txtUsername.text as NSString?)!
                request.password = (txtPassword.text as NSString?)!
                ProxyManager.PreLogin (request, success: {
                    (result) in
                    DispatchQueue.main.async {
                        if result.isSuccess{
                                ProxyManagerData.tokenData = result
                                self.btnLogin.isEnabled = false
                                self.hideBusyIndicator()
                                self.performSegue(withIdentifier: "sw_Accounts", sender: self)
                        }
                        else{
                            self.hideBusyIndicator()
                            self.showAlert("Login Exception Title", messageKey: result.message as String)
                        }
                    }
                },
               failure: { (error) -> Void in
                    DispatchQueue.main.async {
                        self.hideBusyIndicator()
                        self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
                    }
                })
            }
        }
    }
    
    @IBAction func showModal(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let sub: UIViewController = storyboard.instantiateViewController(withIdentifier: "vwAtmModal") as UIViewController
        self.present(sub, animated: true, completion: nil)
    }
    

    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        self.view.endEditing(true);
        if(!statusMenuAnimation){
            statusMenuAnimation = true
            animationView.play()
            menuView.isHidden = false
            imageLogo.bounds.size = CGSize(width: imageLogo.bounds.width / 2, height: imageLogo.bounds.height / 2)
            self.logoTopConstraint.constant = -28
        }
        else{
            statusMenuAnimation = false
            animationView.stop()
            menuView.isHidden = true
            imageLogo.bounds.size = CGSize(width: imageLogo.bounds.width * 2, height: imageLogo.bounds.height * 2)
            self.logoTopConstraint.constant = 0
        }
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        btnLogin.isEnabled = (txtPassword.text?.count)! > 0 && (txtUsername.text?.count)! > 0
        if(txtPassword == textField){
            password = textField.text!
        }
    }
    
    
    
    func PasswordKey(_ key:String){
        var textfield = txtPassword.isFirstResponder ? txtPassword : txtUsername
        

        if( key == NSString(format: "%c",13) as String)
        {
            switch(txtPassword.text?.count as Int!)
            {
            case 0:
                txtPassword.text = ""
                break;
            case 1:
                txtPassword.text = ""
                break;
            default:
               
                let toIndex = txtPassword.text?.index(before: (txtPassword.text?.endIndex)!)
                txtPassword.text = txtPassword.text?.substring(to: toIndex!)
                break
            }
        }
        else{
            txtPassword.text = txtPassword.text! +  key
        }
    }

 func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(UIDevice().userInterfaceIdiom == .pad )
        {
            if(string.count>0)
            {
                let dictionary :String  = (textField.tag == 1 ? "0123456789" : "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890")
                
                let myCharSet : NSCharacterSet = NSCharacterSet(charactersIn: dictionary)
                for i in 0...string.count-1
                {
                    let c : unichar = string.characterAtIndex(index: i)
                    let test = myCharSet.characterIsMember(c)
                    if (!test) {
                        return false;
                    }
                }
            }
        }
        
        return true;
    }
}

