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
        self.keyboardEvent()
        self.title = ""
        menuView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        itemMenuAnimation.addSubview(animationView)
        animationView.loopAnimation = false
        txtUsername.text = "401910830"
        //txtUsername.text = "304220057"
        txtPassword.text = "coope1234$"
        leftBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped(sender:))))
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification)
    {
        self.moveBackView()
    }
    @objc func keyboardWillShow(sender: NSNotification)
    {
        if(self.viewMoved == false){
            moveView()
        }
    }
    
    func moveView()
    {
        self.viewMoved = true
        OperationQueue.main.addOperation(
            {
                if(self.tcTopSpace != nil)
                {
                    let focusControl = self.getFirstResponder()
                    if let textField = focusControl
                    {
                        OperationQueue.main.addOperation(
                            {
                                let keyboardHeight :CGFloat = Constants.iPhone ? 286 : 380
                                let keyboardTop = (self.view.frame.height - keyboardHeight)
                                let fieldY = self.view.convert(textField.center, from: textField.superview!).y  + textField.frame.height
                                
                                if( fieldY  > keyboardTop)
                                {
                                    let n = (keyboardTop - fieldY )
                                    let m = (self.tcTopSpace.constant < 0 ? self.tcTopSpace.constant : 0  ) + n
                                    UIView.animate(withDuration: 0.5 ,animations:{
                                        
                                        self.tcTopSpace.constant = m
                                        self.view.updateConstraintsIfNeeded()
                                        
                                    })
                                    self.viewMoved = false
                                }
                                else
                                {
                                    if(fieldY < 40)
                                    {
                                        UIView.animate(withDuration: 0.5 ,animations:{
                                            
                                            self.tcTopSpace.constant = 30 - fieldY
                                            self.view.updateConstraintsIfNeeded()
                                            
                                        })
                                    }
                                    
                                }
                                
                                self.keyboardIsShown = true
                        })
                    }
                }
                self.viewMoved = false
        })
    }
    
    func moveBackView()
    {
        moveBackView(true)
    }
    func moveBackView(_ animated: Bool)
    {
        if(self.viewMoved == false)
        {
            OperationQueue.main.addOperation(
                {
                    let focusControl = self.getFirstResponder()
                    if focusControl == nil
                    {
                        self.keyboardIsShown = false
                        if(self.tcTopSpace != nil)
                        {
                            if( self.tcTopSpace.constant != 30)
                            {
                                if(animated)
                                {
                                    UIView.animate(withDuration: 0.5 ,animations:{
                                        self.tcTopSpace.constant = 30
                                        self.view.updateConstraintsIfNeeded()
                                    })
                                }
                                else
                                {
                                    self.tcTopSpace.constant = 30
                                    self.view.updateConstraintsIfNeeded()
                                }
                                self.viewMoved = false
                            }
                        }
                    }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        /*statusMenuAnimation = false
        animationView.stop()
        menuView.isHidden = true
        imageLogo.bounds.size = CGSize(width: imageLogo.bounds.width * 2, height: imageLogo.bounds.height * 2)
        self.logoTopConstraint.constant = 35*/
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
            let  entity: AnyObject = PreLoginRequest() //LoginRequest()
            self.showBusyIndicator("Signing in")
            if let request: PreLoginRequest  = entity as? PreLoginRequest{
                request.user = (txtUsername.text as NSString?)!
                request.password = (txtPassword.text as NSString?)!
                ProxyManager.PreLogin (request, success: {
                    (result) in
                    DispatchQueue.main.async {
                        if result.isSuccess{
                                ProxyManagerData.tokenData = result
                            
                                //let  newSideMenue :SidebarViewController = Helper.getViewController("vwLoginSideMenue") as! SidebarViewController
                            
                                //newSideMenue.menuOrder = Constants.loginMenuOrder
                            
                                //let sideBar : SWRevealViewController = self.revealViewController() as SWRevealViewController
                            
                            
                                //sideBar.rearViewController = newSideMenue
                                self.btnLogin.isEnabled = false
                                self.hideBusyIndicator()
                                self.performSegue(withIdentifier: "sw_Accounts", sender: self)
                                //self.performSegue(withIdentifier: "sw_Menu", sender: self)
                        }
                        else{
                                self.hideBusyIndicator()
                                print("Mensaje random0: ",result.message as String)
                                self.showAlert("Login Exception Title", messageKey: result.message as String)
                        }
                    }
                },
               failure: { (error) -> Void in
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: "Login Generic Exception Message")
                })
            }
        }
        
        /*if(Helper.isNumber(txtUsername.text) == false){
            self.showAlert("Invalid Data Title", messageKey: "Username can only have numbers")
        }
        else
        {
            //let  entity: AnyObject = PreLoginRequest() //LoginRequest()
            //self.showBusyIndicator("Signing in")
            //if let request: PreLoginRequest  = entity as? PreLoginRequest
            let  entity: AnyObject = LoginRequest() //LoginRequest()
            //self.showBusyIndicator("Signing in")
            if let request: LoginRequest  = entity as? LoginRequest
            {
                request.user = (txtUsername.text as NSString?)!
                request.password = (txtPassword.text as NSString?)!
                
                ProxyManager.Login (request, success: {
                    (result) in
                    if result.isSuccess
                    {
                        DispatchQueue.main.async {
                            ProxyManagerData.tokenData = result
                            
                            self.btnLogin.isEnabled = false
                            //self.hideBusyIndicator()
                            self.performSegue(withIdentifier: "sw_Accounts", sender: self)
                        }
                    }
                    else
                    {
                       // self.hideBusyIndicator()
                        self.showAlert("Login Exception Title", messageKey: result.message as String)                }
                },
                                       failure: { (error) -> Void in
                                        
                                      //  self.hideBusyIndicator()
                                        self.showAlert("Login Exception Title", messageKey: "Login Generic Exception Message")
                })
            }
        }*/
    }
    
    @IBAction func showModal(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let  sub :UIViewController = storyboard.instantiateViewController(withIdentifier: "vwAtmModal") as UIViewController
        self.present(sub, animated: true, completion: nil)
    }
    
   /* func PasswordKey(_ key: String) {
        var textField = txtPassword.isFirstResponder ? txtPassword : txtUsername
        if( key == NSString(format: "%c", 13) as String) {
            switch(txtPassword.text?.characters.count as Int!)
            {
            case 0...1:
                txtPassword.text = ""
                break;
            default:
                let toIndex = txtPassword.text?.index(before: (txtPassword.text?.endIndex)!)
                txtPassword.text = txtPassword.text?.substring(to: toIndex!)
                break
            }
        }
    }*/
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        if(!statusMenuAnimation){
            statusMenuAnimation = true
            animationView.play()
            menuView.isHidden = false
            imageLogo.bounds.size = CGSize(width: imageLogo.bounds.width / 2, height: imageLogo.bounds.height / 2)
            self.logoTopConstraint.constant = 5
        }
        else{
            statusMenuAnimation = false
            animationView.stop()
            menuView.isHidden = true
            imageLogo.bounds.size = CGSize(width: imageLogo.bounds.width * 2, height: imageLogo.bounds.height * 2)
            self.logoTopConstraint.constant = 35
        }
    }
    
    ///MARK UITextFieldDelegate
    /*override func textFieldDidBeginEditing(_ textField: UITextField) {
        if(txtPassword == textField)
        {
            password = textField.text!
            flag = true
        }
        
        
    }*/
    func textFieldDidEndEditing(_ textField: UITextField) {
        btnLogin.isEnabled = (txtPassword.text?.count)! > 0 && (txtUsername.text?.count)! > 0
        if(Constants.iPhone)
        {
            //            if(btnLogin.enabled && textField == txtPassword){
            //                self.doLogin(btnLogin)
            //            }
            
        }
        if(txtPassword == textField){
            password = textField.text!
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        /*if(Constants.iPad)
        {
            if(string.count>0)
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
            }
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
                    
                    password = textField.text!
                }
                
                return false;
                
            }
        }*/
        return true;
    }
    
    ///Mark PasswordKeyDelegate
    func PasswordKey(_ key:String){
        var textfield = txtPassword.isFirstResponder ? txtPassword : txtUsername
        
        //textfield.resignFirstResponder()
        //textFieldEndEdit(textfield)
        
        if( key == NSString(format: "%c",13) as String)
        {
            switch(txtPassword.text?.count as Int!)
            {
                
            case 0...1:
                txtPassword.text = ""
                
                break;
            default:
                //var toIndex = txtPassword.text?.endIndex.predecessor()
                let toIndex = txtPassword.text?.index(before: (txtPassword.text?.endIndex)!)
                //txtPassword.text = txtPassword.text.substringToIndex(toIndex)
                txtPassword.text = txtPassword.text?.substring(to: toIndex!)
                break
                
            }
        }
        else{
            txtPassword.text = txtPassword.text! +  key
        }
    }


}

