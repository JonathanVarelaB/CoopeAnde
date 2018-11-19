//
//  AlertViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/12/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSi: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnAcceptHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNoHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSiHeight: NSLayoutConstraint!
    
    var titleAlert: String = ""
    var descAlert: String = ""
    var accept: Bool = true
    var sectionType: String = ""
    var controller: BaseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setType()
        self.setDesign()
        self.lblTitle.text = titleAlert
        self.lblDesc.text = descAlert
    }
    
    func setType(){
        self.btnNo.isHidden = self.accept
        self.btnSi.isHidden = self.accept
        self.btnAccept.isHidden = !self.accept
    }
    
    func setDesign(){
        self.viewAlert.layer.cornerRadius = 10
        if self.accept {
            let maskPath1 = UIBezierPath(roundedRect: self.btnAccept.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = self.btnAccept.bounds
            maskLayer1.path = maskPath1.cgPath
            self.btnAccept.layer.mask = maskLayer1
        }
        else{
            let maskPath2 = UIBezierPath(roundedRect: self.btnNo.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer2 = CAShapeLayer()
            maskLayer2.frame = self.btnNo.bounds
            maskLayer2.path = maskPath2.cgPath
            self.btnNo.layer.mask = maskLayer2
            
            let border = CALayer()
            border.borderColor = UIColor.white.cgColor
            border.frame = CGRect(x: self.btnNo.frame.width - 1, y: 10, width: 1, height: self.btnNo.frame.height - 20)
            border.borderWidth = 1
            self.btnNo.layer.addSublayer(border)
            self.btnNo.layer.masksToBounds = true
            
            let maskPath3 = UIBezierPath(roundedRect: self.btnSi.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer3 = CAShapeLayer()
            maskLayer3.frame = self.btnSi.bounds
            maskLayer3.path = maskPath3.cgPath
            self.btnSi.layer.mask = maskLayer3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        if self.sectionType == "timeOut" {
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "initLoginController") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate
            self.dismiss(animated: true, completion: {appDelegate?.window??.rootViewController = signInPage})
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func si(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if controller != nil {
            switch self.sectionType {
            case "eliminarFavorito":
                (self.controller as! SelectFavoriteNumberViewController).alertActionSi()
            case "agregarFavorito":
                //(self.controller as! SelectContactViewController).alertActionSi()
                (self.controller as! SelectFavoriteNumberViewController).addFavorite()
            case "logout":
                (self.controller as! BaseViewController).logoutAction()
            default:
                print("default")
            }
        }
    }
    
    @IBAction func no(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if controller != nil {
            switch self.sectionType {
            case "eliminarFavorito":
                (self.controller as! SelectFavoriteNumberViewController).alertActionNo()
            case "agregarFavorito":
                //(self.controller as! SelectContactViewController).alertActionNo()
                (self.controller as! SelectFavoriteNumberViewController).dontAddFavorite()
            default:
                print("default")
            }
        }
    }
    
}
