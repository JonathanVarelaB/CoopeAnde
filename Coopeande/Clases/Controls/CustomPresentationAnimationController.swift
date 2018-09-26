//
//  CustomPresentationAnimationController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CustomPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let  PresentedViewHeightPortrait = CGFloat(720.0)
    let  PresentedViewHeightLandscape = CGFloat(440.0)
    
    let isPresenting :Bool
    let duration :TimeInterval = 0.5
    var orientation : UIInterfaceOrientation
    {
        get
        {
            return UIApplication.shared.statusBarOrientation
        }
    }
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    
    // ---- UIViewControllerAnimatedTransitioning methods
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        if (isPresenting)
        {
            if(Constants.iOS8)
            {
                animatePresentationWithTransitionContext(transitionContext)
            }
            else
            {
                animatePresentationWithTransitionContextOld(transitionContext)
            }
        }
        else
        {
            if(Constants.iOS8)
            {
                animateDismissalWithTransitionContext(transitionContext)
            }
            else
            {
                animateDismissalWithTransitionContextOld(transitionContext)
            }
        }
    }
    
    
    
    // ---- Helper methods
    
    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView
        
        
        toView.frame = transitionContext.finalFrame(for: toViewController)
        
        if(Constants.iPad)
        {
            toViewController.view.center.x = containerView.center.x
            toViewController.view.frame.origin.y = containerView.bounds.size.height
        }
        else
        {
            toView.center.y += containerView.bounds.size.height
        }
        containerView.addSubview(toView)
        
        // Animate the presented view to it's final position
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations:
            {
                if(Constants.iPad)
                {
                    toViewController.view.frame.origin.y -= toViewController.view.frame.height
                }
                else
                {
                    toView.center.y -= toView.bounds.size.height
                }
                
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
    
    func animatePresentationWithTransitionContextOld(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        
        let view = UIView(frame: containerView.frame)
        view.isOpaque = false
        view.alpha = 0.5
        view.backgroundColor = UIColor.black
        
        toViewController.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        if(Constants.iPad)
        {
            if( orientation == UIInterfaceOrientation.landscapeLeft)
            {
                toViewController.view.center.x += containerView.frame.width
                toViewController.view.center.y = containerView.center.y
            }
            else
            {
                toViewController.view.center.x -= toViewController.view.frame.width
                toViewController.view.center.y = containerView.center.y
                
            }
            
        }
        else
        {
            toViewController.view.center.y += containerView.bounds.size.height
        }
        containerView.addSubview(view)
        containerView.addSubview(toViewController.view)
        
        
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction,
                       animations:
            {
                
                if(Constants.iPad)
                {
                    if( self.orientation == UIInterfaceOrientation.landscapeLeft)
                    {
                        toViewController.view.center.x -= toViewController.view.frame.width
                    }
                    else
                    {
                        toViewController.view.center.x += toViewController.view.frame.width
                        
                    }
                }
                else
                {
                    toViewController.view.center.y -= toViewController.view.bounds.size.height
                }
                
        },
                       completion:{(completed: Bool) -> Void  in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
        }
        )
        
    }
    
    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView
        
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            if(Constants.iPad)
            {
                presentedControllerView.center.y += presentedControllerView.frame.height
                
            }
            else
            {
                presentedControllerView.center.y += presentedControllerView.bounds.size.height
            }
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContextOld(_ transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedControllerView  = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let containerView = transitionContext.containerView
        
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            if(Constants.iPad)
            {
                if( self.orientation == UIInterfaceOrientation.landscapeLeft)
                {
                    presentedControllerView?.center.x += (presentedControllerView?.frame.width)!
                }
                else
                {
                    presentedControllerView?.center.x -= (presentedControllerView?.frame.width)!
                    
                }
                
            }
            else
            {
                presentedControllerView?.center.y += (presentedControllerView?.bounds.size.height)!
            }
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
}
