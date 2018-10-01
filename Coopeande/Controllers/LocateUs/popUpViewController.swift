//
//  popUpViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {
    
    var popUpViewControllerInstance : popUpViewController! = nil
    
    var theParentView: UIView!
    
    var sizeOfPopUpViewContainer:Int!
    
    var popUpViewIsOpen:Bool = false
    
    var needMoreGesture:Bool = false
    
    var backgroundColor:UIColor = UIColor.darkGray
    
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (theParentView.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(popUpViewController.panGesture))
        view.addGestureRecognizer(gesture)
        
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
        popUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        theViewController.addChildViewController(popUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, needMoreGesture:Bool){
        theParentView = senderView
        popUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.needMoreGesture = needMoreGesture
        theViewController.addChildViewController(popUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, backgroundColor:UIColor){
        theParentView = senderView
        popUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.backgroundColor = backgroundColor
        theViewController.addChildViewController(popUpViewControllerInstance)
    }
    
    func crateInstanceOfPopUp(senderView:UIView, theViewController:UIViewController, sizeOfPopUpViewContainer:Int, needMoreGesture:Bool, backgroundColor:UIColor){
        theParentView = senderView
        popUpViewControllerInstance = self
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.needMoreGesture = needMoreGesture
        self.backgroundColor = backgroundColor
        theViewController.addChildViewController(popUpViewControllerInstance)
    }
    
    
    //Add popUP View ot parent view
    func addPopOverView() {
        
        popUpViewIsOpen = true
        
        popUpViewControllerInstance.view.frame.origin.y = theParentView.frame.height
        
        popUpViewControllerInstance.didMove(toParentViewController: popUpViewControllerInstance)
        theParentView.addSubview(popUpViewControllerInstance.view)
        
        let height = theParentView.frame.height
        let width  = theParentView.frame.width
        self.popUpViewControllerInstance.view.frame = CGRect(x: 0, y: self.theParentView.frame.maxY, width: width, height: height)
    }
    
    //Preapre the BackGroundView of the child View
    func prepareBackgroundView(){
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: popUpViewControllerInstance.view.frame.width,
                                                  height: popUpViewControllerInstance.view.frame.height))
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
            self.popUpViewControllerInstance.view.frame = CGRect(x: 0, y: self.theParentView.frame.height, width: self.theParentView.frame.width, height: self.theParentView.frame.height)
        }) { _ in
            self.popUpViewIsOpen = false
            self.popUpViewControllerInstance.view.removeFromSuperview()
        }
    }
    
    //Close popUpView and remove it from Parent or superView
    @IBAction func closePopUpDialog(sender: AnyObject) {
        closePopUpView()
    }
    
    
}
