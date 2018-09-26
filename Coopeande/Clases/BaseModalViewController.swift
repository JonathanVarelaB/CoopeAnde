//
//  BaseModalViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit

class BaseModalViewController: UIViewController,UIViewControllerTransitioningDelegate {

    var ProxyManager :UtilProxyManager = UtilProxyManager()
    
    @IBAction func Close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: onClose)
    }
    
    func onClose()
    {
        
    }
    
    /*init(){
     super.init()
     self.commonInit()
     }*/
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
    }
    fileprivate var hasViewFrameKVO = false
    override func viewDidLoad() {
        self.addObserver(self,forKeyPath:"view.frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],context:nil)
        hasViewFrameKVO = true
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        if(hasViewFrameKVO)
        {
            self.removeObserver(self,forKeyPath:"view.frame")
            hasViewFrameKVO=false
        }
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.view.superview != nil ) && (Constants.iPhone)
        {
            self.view.frame.size.width =  self.view.superview!.frame.width
        }
    }
    
    func observeValue(forKeyPath keyPath: String, of object: AnyObject, change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {
    }
    // ---- UIViewControllerTransitioningDelegate methods
    
    private func presentationController(forPresented presented: UIViewController!, presenting: UIViewController??, source: UIViewController!) -> UIPresentationController! {
        
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presenting: presenting!)
        }
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }

}
