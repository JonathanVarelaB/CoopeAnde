//
//  pageBlueViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Lottie

class SplashAnimatedViewController: UIViewController {

    @IBOutlet weak var constraintForTopTitle: NSLayoutConstraint!
    @IBOutlet weak var labelForTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    let animationView = LOTAnimationView(name: "splash2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.contentView.isHidden = true
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x:0, y: 0, width: self.view.frame.width , height: self.view.frame.height - 48)
        contentView.addSubview(animationView)
        animationView.loopAnimation = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                self.constraintForTopTitle.constant = 9;
            case 1334:
                self.constraintForTopTitle.constant = 10;
            case 2208:
                self.constraintForTopTitle.constant = 9;
            case 2436:
                self.constraintForTopTitle.constant = 38;
            default:
                self.constraintForTopTitle.constant = 44;
            }
        }
        else{
            self.constraintForTopTitle.constant = 32;
        }
        animationView.completionBlock = {(result: Bool) in ()
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.labelForTitle.alpha = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                if (UserDefaults.standard.string(forKey: "IS_FIRST_TIME") == nil)
                {
                    let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "InitialTutorialViewController") as! InitialTutorialViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = signInPage
                    UserDefaults.standard.set("S", forKey: "IS_FIRST_TIME")
                }
                else{
                    let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "initLoginController") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = signInPage
                }
            })
        }
        animationView.play()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
