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

    @IBOutlet weak var contentView: UIView!
    let animationView = LOTAnimationView(name: "splash")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.contentView.isHidden = true
        animationView.contentMode = .scaleToFill
        animationView.frame = CGRect(x:0, y: 0, width: self.view.frame.width , height: self.view.frame.height)
        contentView.addSubview(animationView)
        animationView.loopAnimation = false
        animationView.completionBlock = {(result: Bool) in ()
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "InitialTutorialViewController") as! InitialTutorialViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
        }
        
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
