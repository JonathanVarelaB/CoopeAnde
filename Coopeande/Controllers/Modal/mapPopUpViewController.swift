//
//  mapPopUpViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 18/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import QuartzCore

class mapPopUpViewController: UIViewController {
    
    var mapPopUpViewControllerInstance : mapPopUpViewController! = nil
    
    var theParentView: UIView!
    
    var sizeOfPopUpViewContainer:Int!
    
    var popUpViewIsOpen:Bool = false
    
    var needMoreGesture:Bool = false
    
    var backgroundColor:UIColor = UIColor(red:0.00, green:0.33, blue:0.76, alpha:0.85)
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (theParentView.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }

    @IBOutlet var popUpView: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(mapPopUpViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    open func showInView(_ aView: UIView!, withImage image : UIImage!, withMessage message: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        //logoImg!.image = image
        //messageLabel!.text = message
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction open func closePopup(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    //Preapare popUpView befor appearing
    override func viewWillAppear(_ animated: Bool) {
        
        prepareBackgroundView()
        
    }
    
    //After the ParentView did appear, make the popUp translate to up with some bounce animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - CGFloat.init(self!.sizeOfPopUpViewContainer)
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }){ _ in }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Create an Instance of popUpDialog and declare the parent and child
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int){
        theParentView = senderView
        mapPopUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        theViewController.addChildViewController(mapPopUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, needMoreGesture:Bool){
        theParentView = senderView
        mapPopUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.needMoreGesture = needMoreGesture
        theViewController.addChildViewController(mapPopUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, backgroundColor:UIColor){
        theParentView = senderView
        mapPopUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.backgroundColor = backgroundColor
        theViewController.addChildViewController(mapPopUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, needMoreGesture:Bool, backgroundColor:UIColor){
        theParentView = senderView
        mapPopUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.needMoreGesture = needMoreGesture
        self.backgroundColor = backgroundColor
        theViewController.addChildViewController(mapPopUpViewControllerInstance)
    }
    
    
    //Add popUP View ot parent view
    func addPopOverView() {
        
        popUpViewIsOpen = true
        
        mapPopUpViewControllerInstance.view.frame.origin.y = theParentView.frame.height
        
        mapPopUpViewControllerInstance.didMove(toParentViewController: mapPopUpViewControllerInstance)
        theParentView.addSubview(mapPopUpViewControllerInstance.view)
        
        let height = theParentView.frame.height
        let width  = theParentView.frame.width
        self.mapPopUpViewControllerInstance.view.frame = CGRect(x: 0, y: self.theParentView.frame.maxY, width: width, height: height)
    }
    
    //Preapre the BackGroundView of the child View
    func prepareBackgroundView(){
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: mapPopUpViewControllerInstance.view.frame.width,
                                                  height: mapPopUpViewControllerInstance.view.frame.height))
        backgroundView.layer.backgroundColor = backgroundColor.cgColor
        backgroundView.frame = UIScreen.main.bounds
        
        view.insertSubview(backgroundView, at: 0)
        
    }
    
    
    
    //PenGEsture help the view to translate and be added to the parent view
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        if (needMoreGesture) {
            let translation = recognizer.translation(in: self.view)
            let velocity = recognizer.velocity(in: self.view)
            let y = self.view.frame.minY
            if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
                self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            
            if recognizer.state == .ended {
                var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
                
                duration = duration > 1.3 ? 1 : duration
                
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                    if  velocity.y >= 0 {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    }
                    
                }, completion: nil)
            }
        }
        
    }
    
    func openPopUpView(){
        
        if (self.popUpViewIsOpen) {
            closePopUpView()
        }else{
            addPopOverView()
        }
        
    }
    
    func closePopUpView(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mapPopUpViewControllerInstance.view.frame = CGRect(x: 0, y: self.theParentView.frame.height, width: self.theParentView.frame.width, height: self.theParentView.frame.height)
        }) { _ in
            self.popUpViewIsOpen = false
            self.mapPopUpViewControllerInstance.view.removeFromSuperview()
        }
    }
    
    //Close popUpView and remove it from Parent or superView
    @IBAction func closePopUpDialog(sender: AnyObject) {
        closePopUpView()
    }
}
