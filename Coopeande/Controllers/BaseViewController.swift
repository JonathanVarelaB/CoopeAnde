//
//  BaseViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 24/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class BaseViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var tcTopSpace: NSLayoutConstraint!
    var keyboardIsShown : Bool = false
    var viewMoved : Bool = false
    var ProxyManager :UtilProxyManager = UtilProxyManager()
    var doEndSession : Bool = false
    var removedFromParent :Bool = false
    weak var poSimpleTable : UIPopoverPresentationController?
    
    fileprivate var originalValue : CGFloat = 30
    override func removeFromParentViewController()
    {
        removedFromParent = true
        super.removeFromParentViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let textFields = self.view.subviews.filter(){
            $0.isKind(of: UITextField.self) && $0.isFirstResponder
        }
        for textField in textFields
        {
            self.textFieldDidEndEdit(textField as! UITextField)
        }
        self.view.endEditing(true)
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //BaseViewController.setNavigation(titleView: self.title!,controller: self)
        
       /* self.navigationItem.hidesBackButton = true
        //let menuItem = UIBarButtonItem(title: "Menú", style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuSide(sender:)))
        let menuItem = UIBarButtonItem(image: UIImage(named: "Menu"), landscapeImagePhone: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = view.frame.width * 0.80
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)*/

        // Do any additional setup after loading the view.
        //Jonathan
        //self.keyboardEvent()
        //
    }
    /*print("ProxyManagerData.logout " , ProxyManagerData.logout)
     if ProxyManagerData.logout {
     print("LOGOUT1")
     self.logoutAlert()
     }*/
    
    func assignProductSelect(product: SelectableProduct, type: String){}
    func cleanProductSelect(type: String){}
    func openContacts(){}
    func openFavorites(){}
    func alertActionSi(){}
    func alertActionNo(){}
    
    func showAlertPhoneNumber(controller: BaseViewController, section: String){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AlertPhoneNumberViewController") as! AlertPhoneNumberViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.set(controller: controller, section: section)
        self.present(vc, animated: true, completion: nil)
    }
    
    func showAlert(_ titleKey: String?, messageKey: String?, acceptType: Bool = true, controller: BaseViewController = BaseViewController(), sectionType: String = "")
    {
        if(self.isViewLoaded)
        {
            let m : String = messageKey == nil ?  "Generic Error Message" : messageKey!
            let t : String = titleKey == nil ? "Error Title" : titleKey!
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            //vc.definesPresentationContext = true
            vc.titleAlert = Helper.getLocalizedText(t)
            vc.descAlert = Helper.getLocalizedText(m)
            vc.sectionType = sectionType
            if !acceptType {
                vc.accept = acceptType
                vc.controller = controller
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func logoutAlert(){
        self.showAlert("Confimación", messageKey: "¿Está seguro que desea cerrar la sesión?", acceptType: false, controller: self, sectionType: "logout")
    }
    
    func logoutAction(){
        self.showBusyIndicator("Logging Out")
        ProxyManager.Logout( {(result) in
            DispatchQueue.main.async {
                self.closeSession()
            }}, failure: { (error) -> Void in
                self.closeSession()
        })
    }
    
    func closeSession(){
        ProxyManagerData.baseRequestData = nil
        ProxyManagerData.tokenData = nil
        ProxyManagerData.actualController = nil
        self.hideBusyIndicator()
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "initLoginController") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
        
    func showMenu() {
         self.navigationItem.hidesBackButton = true
         //let menuItem = UIBarButtonItem(title: "Menú", style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuSide(sender:)))
         let menuItem = UIBarButtonItem(image: UIImage(named: "menuCustom"), landscapeImagePhone: UIImage(named: "menuCustom"), style: .plain, target: self, action: #selector(menuSide(sender:)))
         self.navigationItem.leftBarButtonItem = menuItem
         
         let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
         SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
         menuLeftNavigationController.menuWidth = view.frame.width * 0.80
         SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
         SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }
    
    @objc func menuSide(sender: UIBarButtonItem) {
        let menu = SideMenuManager.default.menuLeftNavigationController!
        self.parent?.present(menu, animated: true, completion: nil)
        //[self.parent presentViewController:self.menuAlert animated:YES completion:nil];
        //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NSLog("%@","agregado" + self.description)
        // register for keyboard notifications
        //NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        // register for keyboard notifications
        //NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("se quito" + self.description)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        super.viewWillDisappear(animated)
    }
    
    //Jonathan
    /*
    func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }*/
    

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let id = identifier
        {
            if( id == "swLogout")
            {
                return true
            }
        }
        
        if(self.view?.viewWithTag(999) != nil)
        {
            return false
        }
        return true;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    @nonobjc func textFieldDidEndEdit(_ textField:UITextField)
    {
    }
    
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textFieldDidEndEdit(textField)
        return true
    }
    */
    class func setNavigation(titleView: String, controller: UIViewController)
    {
        /// Sidebar data
        controller.title = titleView;
        
        if let sb = controller.navigationItem.leftBarButtonItem
        {
            sb.target = controller.revealViewController()
            sb.action = #selector(SWRevealViewController.revealToggle(_:));
            sb.image = Style.navBarButtonImage;
            sb.tintColor = Style.navBarTintColor;
            sb.style = UIBarButtonItemStyle.bordered
            sb.titlePositionAdjustment(for: UIBarMetrics.compactPrompt)
            sb.customView?.backgroundColor = UIColor.red
            sb.title = "I"
            sb.imageInsets  = UIEdgeInsets(top:0 ,left:0 ,bottom: 0, right: 0)
            controller.navigationItem.title = controller.title
            
        }
        //controller.navigationController?.setNavigationBarHidden(false  , animated: false)
        
        setNavigationStyle(controller: controller)
        if let reveal = controller.revealViewController()
        {
            controller.view.addGestureRecognizer(reveal.panGestureRecognizer());
        }
    }
    
    class func setNavigationStyle(controller: UIViewController)
    {
        if let login = controller as? LoginViewController
        {
            Style.navBarStyleForLogin(controller.navigationController?.navigationBar);
        }
        else
        {
            if controller is SidebarViewController {
                Style.navBarStyleForMain(controller.navigationController?.navigationBar)
            }
            else
            {
                if Style.isLoginBarStyleApply {
                    Style.navBarStyle(controller.navigationController?.navigationBar)
                }}
        }
        
    }
    
    func animateChangedValue(_ label:UILabel)
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 0.9 as Float)
        animation.duration = 0.5
        animation.repeatCount = 2.0
        
        label.layer.add(animation, forKey: nil)
        
        
    }
    
    func sessionTimeOutException(_ code:String) -> Bool
    {
        
        if(Constants.loggoutCode.range(of: code + "|") != nil)
        {
            sessionTimeOut()
            return true
        }
        
        return false
    }
    func sessionTimeOut()
    {
        ProxyManagerData.baseRequestData = nil
        ProxyManagerData.tokenData = nil
        ProxyManagerData.actualController = nil
        self.doEndSession = true
        //self.showAlert( "Your session has expired title", messageKey: "Your session has expired")
        self.showAlert("Your session has expired title", messageKey: "Your session has expired", acceptType: true, controller: self, sectionType: "timeOut")
    }
    
    /*func sessionTimeOutException(code:String, message : String) -> Bool
     {
     
     if(Constants.loggoutCode.rangeOfString(code + "|") != nil)
     {
     sessionTimeOut(message)
     return true
     }
     
     return false
     }
     func sessionTimeOut(message : String)
     {
     ProxyManagerData.baseRequestData = nil
     ProxyManagerData.tokenData = nil
     self.doEndSession = true
     self.showAlert( "Your session has expired title", messageKey: message)
     }*/
    
   /* @objc override func modalAlertCompleted()
    {
        if(self.doEndSession)
        {
            if let sideBar : SWRevealViewController = self.revealViewController()
            {
                self.endSession(self)
            }
            self.endSession(self)
        }
    }
    @objc override func modalAlertOk(_ action:UIAlertAction)
    {
        if(self.doEndSession)
        {
            self.endSession(self)
        }
    }*/
    
    /// mark UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView,
                   clickedButtonAt buttonIndex: Int)
    {
        if(self.doEndSession)
        {
            self.endSession(self)
        }
    }
    fileprivate func  endSession(_ controller:UIViewController)
    {
        /*if let sideBar : SWRevealViewController = controller as? SWRevealViewController
        {
            if let menu = sideBar.rearViewController as? SidebarViewController
            {
                while (self.presentedViewController?.isBeingPresented == true) || (self.presentedViewController?.isBeingDismissed == true)
                {}
                menu.self.performSegue(withIdentifier: "swLogout", sender: self)
                
            }
            
        }*/
       /* if let sideBar : SWRevealViewController = controller.revealViewController()
        {
            self.endSession(sideBar)
        }
        else
        {
            if let parent = controller.presentingViewController
            {
                self.endSession(parent)
            }
                
            else
            {
                if let parent = controller.navigationController?.parent
                {
                    self.endSession(parent)
                }
            }
        } */
    }
    func getFirstResponder() -> UIView?
    {
        return self.getFirstResponder (self.view)
    }
    /*func setFormattedText(_ textView:UITextView, mainText:String,additional:String)
    {
        textView.text = additional.count > 0 ? mainText + "\n" + additional : mainText
        let data  = textView.textStorage
        data.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue-Bold", size:15.0)!, range:NSMakeRange(0, mainText.length));
        if(additional.count > 0)
        {
            data.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue", size:15.0)!, range:NSMakeRange(mainText.length, additional.length + 1));
        }
        
        var topCorrect : CGFloat = CGFloat((textView.bounds.size.height - textView.contentSize.height * textView.zoomScale))
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        textView.contentOffset = CGPoint(x:0, y: -topCorrect);
    }
    func setFormattedTextRight(_ textView:UITextView, mainText:String,additional:String)
    {
        var alignment = CTTextAlignment.kCTRightTextAlignment
        let alignmentSetting = [CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment)]
        let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, 1)
        
        
        textView.text = additional.count > 0 ? mainText + "\n" + additional : mainText
        let data  = textView.textStorage
        data.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue-Bold", size:15.0)!, range:NSMakeRange(0, mainText.length));
        if(additional.count > 0)
        {
            data.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue", size:15.0)!, range:NSMakeRange(mainText.length, additional.length + 1));
        }
        
        var topCorrect : CGFloat = CGFloat((textView.bounds.size.height - textView.contentSize.height * textView.zoomScale))
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        textView.contentOffset = CGPoint(x:0, y: -topCorrect);
        textView.textAlignment = NSTextAlignment.right
        
    }*/
    
    func getFirstResponder(_ root: UIView) -> UIView?
    {
        for item in root .subviews
        {
            if let control  = item as? UIView
            {
                if( control.isFirstResponder)
                {
                    return control
                }
                else
                    if( control.subviews.count > 0)
                    {
                        let result = self.getFirstResponder(control)
                        if(result != nil)
                        {
                            return result
                        }
                }
            }
        }
        return nil
    }
    
    func disableButton(btn: UIButton){
        btn.isEnabled = false
        btn.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
    }
    
    func enableButton(btn: UIButton){
        btn.backgroundColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:1.0)
        btn.isEnabled = true
    }
    
    /*
    func presentAlert(title: String, desc: String){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.titleAlert = title
        vc.descAlert = desc
        self.present(vc, animated: true, completion: nil)
    }*/
    
    /*
    @objc func keyboardWillHide(sender: NSNotification)
    {
        //print("2")
        self.moveBackView()
    }
    @objc func keyboardWillShow(sender: NSNotification)
    {
        if(self.viewMoved == false)
        {
            //print("1")
            moveView()
        }
    }*/
    /*
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
                            if( self.tcTopSpace.constant != self.originalValue)
                            {
                                if(animated)
                                {
                                    UIView.animate(withDuration: 0.5 ,animations:{
                                        self.tcTopSpace.constant = self.originalValue
                                        self.view.updateConstraintsIfNeeded()
                                    })
                                }
                                else
                                {
                                    self.tcTopSpace.constant = self.originalValue
                                    self.view.updateConstraintsIfNeeded()
                                }
                                self.viewMoved = false
                            }
                        }
                    }
            })
        }
    }
    */
    /*
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
                                            
                                            self.tcTopSpace.constant = self.originalValue - fieldY
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
    }*/
}
