//
//  AlertPhoneNumberViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/21/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AlertPhoneNumberViewController: UIViewController {

    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnContacts: UIButton!
    @IBOutlet weak var viewMain: UIView!
    
    var mainController: BaseViewController?
    var sectionType: String = ""

    func set(controller: BaseViewController, section: String){
        self.mainController = controller
        self.sectionType = section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
    }

    func setDesign(){
        self.viewMain.layer.cornerRadius = 10
        self.btnContacts.layer.cornerRadius = 3
        self.btnFavorites.layer.cornerRadius = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openFavorites(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if self.mainController != nil {
            switch self.sectionType {
            case "sinpeAfiliacion":
                (self.mainController as! AffiliationViewController).openFavorites()
                break
            case "sinpeTransaccion":
                (self.mainController as! SinpeTransactionsViewController).openFavorites()
                break
            default:
                print("default")
            }
        }
    }
    
    @IBAction func openContacts(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if self.mainController != nil {
            switch self.sectionType {
            case "sinpeAfiliacion":
                (self.mainController as! AffiliationViewController).openContacts()
            case "sinpeTransaccion":
                (self.mainController as! SinpeTransactionsViewController).openContacts()
                break
            default:
                print("default")
            }
        }
    }

}
