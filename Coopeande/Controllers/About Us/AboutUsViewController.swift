//
//  AboutUsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Acerca de"
        self.viewMain.layer.cornerRadius = 5
        self.viewHeader.layer.cornerRadius = 5
        self.viewBody.layer.cornerRadius = 5
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.4).cgColor
        border.frame = CGRect(x: 5, y: (self.lblTitle.frame.size.height) - 1, width: (self.view.frame.size.width) - 60, height: 1)
        border.borderWidth = 1
        self.lblTitle.layer.addSublayer(border)
        self.lblTitle.layer.masksToBounds = true
        self.backAction()
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
