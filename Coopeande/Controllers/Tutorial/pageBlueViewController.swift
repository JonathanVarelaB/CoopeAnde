//
//  pageBlueViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Lottie

class pageBlueViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    let animationView = LOTAnimationView(name: "step_1")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.contentView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x:0, y: 0, width:self.view.frame.width*0.8, height: self.view.frame.height * 0.5)

        
        contentView.addSubview(animationView)
        animationView.loopAnimation = false
        animationView.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "initLoginController") as UIViewController
        self.present(vc, animated: true, completion: nil)
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
