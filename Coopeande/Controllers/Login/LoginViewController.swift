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
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChangePassword: UIButton!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewKeyboard: UIView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardWidth: NSLayoutConstraint!
    @IBOutlet weak var viewKeyboardWidth: NSLayoutConstraint!
    @IBOutlet weak var keyboard: UIView!
    
    
    let animationView = LOTAnimationView(name: "menu")
    var statusMenuAnimation : Bool = false
    var virtualKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.disableButton(btn: self.btnLogin)
        self.txtPassword.clearsOnInsertion = false
        self.txtPassword.clearsOnBeginEditing = false
        self.keyboardEvent()
        Constants.iPhone ? self.setMenu() : nil
        txtUsername.delegate = self
        txtPassword.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func setMenu(){
        self.logoTopConstraint.constant = -20
        menuView.layer.opacity = 0
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        itemMenuAnimation.addSubview(animationView)
        animationView.loopAnimation = false
        leftBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped(sender:))))
    }
    
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y = 64
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        if Constants.iPhone {
            self.view.frame.origin.y = -80
        }
        else if UIApplication.shared.statusBarOrientation.isLandscape{
            if self.txtUsername.isFirstResponder {
                self.view.frame.origin.y = -60
            }
            else{
                self.view.frame.origin.y = -130
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        (self.isViewLoaded && (self.view!.window != nil)) ? self.designScreenOrientation() : nil
    }
    
    func designScreenOrientation(){
        DispatchQueue.main.async() {
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.logoAnimationView.frame.origin.y = -120
                self.imageLogo.frame.origin = CGPoint(x: 50, y: 100)
                self.menuView.frame.origin = CGPoint(x: UIScreen.main.bounds.width - (self.menuView.frame.width + 20), y: 120)
                self.lblTitle.frame.origin.y = 220
                self.viewUserName.frame.origin = CGPoint(x: ((UIScreen.main.bounds.width / 2) - (self.viewUserName.frame.width)) / 2, y: 370)
                self.viewPassword.frame.origin = CGPoint(x: ((UIScreen.main.bounds.width / 2) - (self.viewPassword.frame.width)) / 2, y: 450)
                self.lblChangePassword.frame.origin = CGPoint(x: ((UIScreen.main.bounds.width / 2) - (self.viewPassword.frame.width)) / 2, y: 510)
                self.viewButton.frame.origin = CGPoint(x: ((UIScreen.main.bounds.width * -1) / 2) + (((UIScreen.main.bounds.width / 2) - (self.viewPassword.frame.width)) / 2) + 160, y: 580)
                self.viewKeyboard.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: 330, width: 490, height: 300)
                self.keyboardHeight.constant = 218
                self.keyboardWidth.constant = 270
            }
            else{
                self.keyboardHeight.constant = 114
                self.keyboardWidth.constant = 530
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.designScreenOrientation()
        self.txtUsername.text = ""
        self.txtPassword.text = ""
        //txtUsername.text = "401910830"
        //txtUsername.text = "304220057"
        //txtPassword.text = "coope123$"
        //self.doLogin(UIButton())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "swPasswordKeyboard"{
            if let sg = segue.destination as? PasswordKeyboard{
                sg.delegate = self
                sg.section = "login"
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
    
    func validTxt(txt: UITextField){
        self.maxLenght(textField: txt, maxLength: 30)
        if txt.text?.last == " " {
            txt.deleteBackward()
        }
    }
    
    @IBAction func changeUser(_ sender: UITextField) {
        self.txtUsername.text = Helper.validNumber(sender.text)
        self.validTxt(txt: sender)
        self.validForm()
    }
    
    @IBAction func changePassword(_ sender: UITextField) {
        if Constants.iPad && !self.virtualKeyboard && (self.txtPassword.text?.count)! > 0 {
            let ACCEPTABLE_CHARACTERS = "abcdefghijklmnopqrstuvwxyz0123456789"
            let last: String = (self.txtPassword.text?.last!.description)!
            if ACCEPTABLE_CHARACTERS.range(of: last.lowercased()) == nil {
                self.txtPassword.text?.removeLast()
            }
        }
        self.validTxt(txt: sender)
        self.validForm()
        self.virtualKeyboard = false
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        self.view.endEditing(true);
        if(!self.statusMenuAnimation){
            self.statusMenuAnimation = true
            self.animationView.play()
            self.logoHeight.constant = 110
            self.logoWidth.constant = 140
            self.logoTopConstraint.constant = -50
        }
        else{
            self.statusMenuAnimation = false
            self.animationView.stop()
            self.logoHeight.constant = 150
            self.logoWidth.constant = 200
            self.logoTopConstraint.constant = -20
        }
        UIView.animate(withDuration: 0.3) {
            self.menuView.layer.opacity = (self.statusMenuAnimation) ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername{
            self.txtPassword.becomeFirstResponder()
            if UIApplication.shared.statusBarOrientation.isLandscape{
                self.view.frame.origin.y = -130
            }
        }
        else{
            self.view.endEditing(true)
        }
        return true
    }
    
    func PasswordKey(_ key:String) {
        if key == NSString(format: "%c",13).description {
            if (txtPassword.text?.count)! < 2{
                txtPassword.text = ""
            }
            else{
                self.txtPassword.text?.removeLast()
            }
        }
        else{
            if (self.txtPassword.text?.count)! < 30 {
                self.virtualKeyboard = true
                self.txtPassword.text = self.txtPassword.text! + key
            }
        }
        self.validForm()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnLogin)
        if self.txtUsername.text != "" && self.txtPassword.text != "" {
            self.enableButton(btn: self.btnLogin)
        }
    }
    
}


